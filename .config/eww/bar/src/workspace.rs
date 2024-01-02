use std::collections::BTreeSet;
use std::env;
use std::io::{BufReader, Read, Write};
use std::os::unix::net::UnixStream;
use std::path::{Path, PathBuf};
use std::process::{exit, Command};

pub fn print_workspaces(exec_path: &Path, workspaces: &BTreeSet<u8>, focused: u8) {
	const OTHER_ICON: &str = "";
	const ICONS: [&str; 7] = ["", "", "", "", "", "", ""];

	print!("(eventbox :onscroll '{} {{}}' ", exec_path.display());
	print!("(box :class 'works' :orientation 'v' :space-evenly false");

	#[inline]
	fn print_button(index: u8, class: &str, icon: &str) {
		print!(" (button :tooltip 'Workspace {}' ", index);

		print!(":onclick 'hyprctl dispatch workspace {}' ", index);
		print!(":onrightclick 'hyprctl dispatch workspace {}' ", index);

		print!(":class '{}' '{}')", class, icon);
	}

	let mut workspaces = workspaces.clone();

	for (index, icon) in ICONS.iter().enumerate() {
		let index = index as u8 + 1;

		let mut class = "inactive";

		if workspaces.remove(&index) {
			class = "visible";
		}

		if index == focused {
			class = "active";
		}

		print_button(index, class, icon);
	}

	for index in workspaces {
		let mut class = "visible";

		if index == focused {
			class = "active";
		}

		print_button(index, class, OTHER_ICON);
	}

	println!("))");
}

pub fn main() -> std::io::Result<()> {
	arg_handle();

	let sock_dir = match env::var("HYPRLAND_INSTANCE_SIGNATURE") {
		Ok(sig) => PathBuf::from(format!("/tmp/hypr/{}/", sig)),
		Err(msg) => panic!("{}", msg),
	};

	let (mut workspaces, mut focused_workspace) = init(&sock_dir).unwrap();

	let stream_path = format!("{}.socket2.sock", sock_dir.display());
	println!("; Connecting to: {stream_path}...");

	let stream = UnixStream::connect(stream_path)?;
	let mut reader = BufReader::new(stream);

	let exec_path: PathBuf = env::current_exe()?;

	println!("; Succeed!");

	print_workspaces(&exec_path, &workspaces, focused_workspace);

	loop {
		let mut bytes = vec![0; 1024];

		if let Ok(0) | Err(_) = reader.read(&mut bytes) {
			continue;
		}

		let buffer = String::from_utf8_lossy(&bytes);

		if update(&buffer, &mut workspaces, &mut focused_workspace) {
			print_workspaces(&exec_path, &workspaces, focused_workspace);
		}
	}
}

pub fn init(sock_dir: &Path) -> Option<(BTreeSet<u8>, u8)> {
	#[inline]
	fn get_number(buf: &str) -> u8 {
		let buf = buf[13 .. 15].trim_end();
		buf.parse::<u8>().expect("Failed to parse number.")
	}

	let mut workspaces: BTreeSet<u8> = BTreeSet::new();

	let stream_path = format!("{}.socket.sock", sock_dir.display());

	println!("; Connecting to: {}...", stream_path);
	let mut stream = UnixStream::connect(&stream_path).ok()?;

	let mut output = String::new();
	stream.write_all(b"activeworkspace").ok()?;
	stream.read_to_string(&mut output).ok()?;

	let focused = get_number(&output);

	stream = UnixStream::connect(stream_path).ok()?;

	output.clear();
	stream.write_all(b"workspaces").ok()?;
	stream.read_to_string(&mut output).ok()?;

	for line in output.lines() {
		if !line.starts_with("workspace ID") {
			continue;
		}

		let workspace_id = get_number(line);
		workspaces.insert(workspace_id);
	}

	Some((workspaces, focused))
}

pub fn update(buffer: &str, workspaces: &mut BTreeSet<u8>, focused: &mut u8) -> bool {
	let mut changed = false;

	let get_number = |buf: &str| buf.parse::<u8>().expect("Failed to parse number.");

	for line in buffer.lines() {
		if let Some(num) = line.strip_prefix("workspace>>") {
			*focused = get_number(num);
			changed = true;

			continue;
		}

		if let Some(num) = line.strip_prefix("createworkspace>>") {
			workspaces.insert(get_number(num));
			changed = true;

			continue;
		}

		if let Some(num) = line.strip_prefix("destroyworkspace>>") {
			let destroyed = get_number(num);

			if workspaces.remove(&destroyed) {
				changed = true;
			}
		}
	}

	changed
}

pub fn arg_handle() {
	let mut arg_it = env::args().skip(1);

	let Some(arg) = arg_it.next() else { return };

	if arg_it.next().is_some() {
		panic!("Too many arguments.");
	}

	let mut command = Command::new("hyprctl");
	let mut args_command = vec!["dispatch", "workspace"];

	match arg.as_str() {
		"up" => args_command.push("e-1"),
		"down" => args_command.push("e+1"),

		_ => panic!("Invalid argument: {}", arg),
	};

	if command.args(args_command).spawn().is_err() {
		panic!("Failed to execute command.");
	}

	exit(0);
}

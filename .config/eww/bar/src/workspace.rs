use std::collections::BTreeSet;
use std::env::{args, current_exe, var};
use std::io::{BufReader, Read, Write};
use std::os::unix::net::UnixStream;
use std::path::{Path, PathBuf};
use std::process::{exit, Command};

pub fn print_workspaces(exec_path: &Path, workspaces: &BTreeSet<u8>, focused: u8) {
	const OTHER_ICON: &str = "";
	const ICONS: [&str; 7] = ["", "", "", "", "", "", ""];

	let mut workspaces = workspaces.clone();

	print!("(eventbox :onscroll '{} {{}}' ", exec_path.display());
	print!("(box :class 'works' :orientation 'v' :space-evenly false");

	for (index, icon) in ICONS.iter().enumerate() {
		let index = index as u8 + 1;

		print!(" (button :tooltip 'Workspace {}' ", index);

		print!(":onclick 'hyprctl dispatch workspace {}' ", index);
		print!(":onrightclick 'hyprctl dispatch workspace {}' ", index);

		let class: &'static str = match index {
			_ if index == focused => "active",
			i if workspaces.contains(&i) => "visible",
			_ => "inactive",
		};

		if workspaces.contains(&index) {
			workspaces.remove(&index);
		}

		print!(":class '{}' '{}')", class, icon);
	}

	for &index in workspaces.iter() {
		print!(" (button :tooltip 'Workspace {}' ", index);

		if index == focused {
			print!(":class 'active' '{}')", OTHER_ICON);
			continue;
		}

		print!(":onclick 'hyprctl dispatch workspace {}' ", index);
		print!(":onrightclick 'hyprctl dispatch workspace {}' ", index);

		print!(":class 'visible' '{}')", OTHER_ICON);
	}

	println!("))");
}

pub fn main() -> std::io::Result<()> {
	arg_handle();

	let sock_dir = match var("HYPRLAND_INSTANCE_SIGNATURE") {
		Ok(sig) => PathBuf::from(format!("/tmp/hypr/{}/", sig)),
		Err(msg) => panic!("{}", msg),
	};

	let (mut workspaces, mut focused_workspace) = init(&sock_dir).unwrap();

	let stream_path = format!("{}.socket2.sock", sock_dir.display());
	println!("; Connecting to: {stream_path}...");

	let stream = UnixStream::connect(stream_path)?;
	let mut reader = BufReader::new(stream);

	let exec_path: PathBuf = current_exe()?;

	println!("; Successed!");

	print_workspaces(&exec_path, &workspaces, focused_workspace);

	loop {
		let mut bytes = [0; 1024];
		let _ = reader.read(&mut bytes)?;

		let buffer = std::str::from_utf8(&bytes).unwrap();

		if update(buffer, &mut workspaces, &mut focused_workspace) {
			print_workspaces(&exec_path, &workspaces, focused_workspace);
		}
	}
}

pub fn init(sock_dir: &Path) -> Option<(BTreeSet<u8>, u8)> {
	let mut workspaces: BTreeSet<u8> = BTreeSet::new();

	fn get_number(buf: &str) -> u8 {
		let buf = buf[13 .. 15].trim_end();
		buf.parse::<u8>().unwrap()
	}

	let stream_path = format!("{}.socket.sock", sock_dir.display());

	println!("; Connecting to: {stream_path}...");
	let mut stream = UnixStream::connect(&stream_path).ok()?;

	let mut output = String::new();
	stream.write_all(b"activeworkspace").ok()?;
	stream.read_to_string(&mut output).ok()?;

	let focused = get_number(&output);
	stream.shutdown(std::net::Shutdown::Both).ok()?;

	let mut stream = UnixStream::connect(stream_path).ok()?;

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

	let get_number = |buf: &str| buf.parse::<u8>().unwrap();

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

			if workspaces.contains(&destroyed) {
				workspaces.remove(&destroyed);
				changed = true;
			}
		}
	}

	changed
}

pub fn arg_handle() {
	let args: Vec<String> = args().collect();

	if args.len() == 1 {
		return;
	}

	assert!(args.len() == 2, "Too many arguments.");

	let mut command = Command::new("hyprctl");
	let mut args_command = vec!["dispatch", "workspace"];

	match args[1].as_str() {
		"up" => args_command.push("e-1"),
		"down" => args_command.push("e+1"),

		_ => panic!("Invalid argument."),
	};

	command.args(args_command).spawn().unwrap();

	exit(0);
}

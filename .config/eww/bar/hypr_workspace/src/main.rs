use std::collections::BTreeSet;
use std::io::{BufRead, BufReader, Read, Write};
use std::os::unix::net::UnixStream;
use std::path::PathBuf;

pub fn print_workspaces(exec_path: &PathBuf, workspaces: &BTreeSet<u8>, focused: &u8) {
	const OTHER_ICON: &str = "";
	const ICONS: [&str; 7] = ["", "", "", "", "", "", ""];

	let mut workspaces = workspaces.clone();

	print!("(eventbox :onscroll \"{} {{}}\" ", exec_path.display());
	print!("(box :class 'works' :orientation 'v' :space-evenly false");

	for (index, icon) in ICONS.iter().enumerate() {
		let index = index as u8 + 1;

		print!(" (button :tooltip 'Workspace {index}' ");

		print!(":onclick 'hyprctl dispatch workspace {index}' ");
		print!(":onrightclick 'hyprctl dispatch workspace {index}' ");

		let class = match index {
			_ if index == *focused => "focused",
			i if workspaces.contains(&i) => "active",
			_ => "inactive",
		};

		if workspaces.contains(&index) {
			workspaces.remove(&index);
		}

		print!(":class '{class}' '{icon}')");
	}

	for &index in workspaces.iter() {
		let index = index as u8 + 1;

		print!(" (button :tooltip 'Workspace {index}'");

		if index == *focused {
			print!(":class 'focused' '{OTHER_ICON}')");
			continue;
		}

		print!(":onclick 'hyprctl dispatch workspace {index}' ");
		print!(":onrightclick 'hyprctl dispatch workspace {index}' ");

		print!(":class 'active' '{OTHER_ICON}')");
	}

	println!("))");
}

pub fn main() {
	let sock_dir = match std::env::var("HYPRLAND_INSTANCE_SIGNATURE") {
		Ok(sig) => PathBuf::from(format!("/tmp/hypr/{sig}/")),
		Err(msg) => panic!("{}", msg),
	};

	let (mut workspaces, mut focused_workspace) = init(&sock_dir).unwrap();

	let stream_path = format!("{}.socket2.sock", sock_dir.display());
	println!("; Connecting to: {stream_path}...");

	let stream = UnixStream::connect(stream_path).unwrap();
	let mut reader = BufReader::new(stream);

	let exec_path: PathBuf = std::env::current_exe().unwrap();

	println!("; Successed!");

	print_workspaces(&exec_path, &workspaces, &focused_workspace);

	loop {
		let mut buffer = String::new();
		reader.read_line(&mut buffer).unwrap();

		if update(buffer, &mut workspaces, &mut focused_workspace) {
			print_workspaces(&exec_path, &workspaces, &focused_workspace);
		}
	}
}

pub fn init(sock_dir: &PathBuf) -> Option<(BTreeSet<u8>, u8)> {
	let mut workspaces: BTreeSet<u8> = BTreeSet::new();

	let stream_path = format!("{}.socket.sock", sock_dir.display());

	println!("; Connecting to: {stream_path}...");
	let mut stream = UnixStream::connect(&stream_path).ok()?;

	let mut output = String::new();
	stream.write(b"j/activeworkspace").ok()?;
	stream.read_to_string(&mut output).ok()?;

	let focused = json::parse(&output).ok()?["id"].as_u8()?;
	stream.shutdown(std::net::Shutdown::Both).ok()?;

	let mut stream = UnixStream::connect(stream_path).ok()?;

	output.clear();
	stream.write(b"j/workspaces").ok()?;
	stream.read_to_string(&mut output).ok()?;

	for workspace in json::parse(&output).ok()?.members() {
		let id = workspace["id"].as_u8()?;
		workspaces.insert(id);
	}

	return Some((workspaces, focused));
}

pub fn update(buf: String, workspaces: &mut BTreeSet<u8>, focused: &mut u8) -> bool {
	let mut changed = false;

	fn get_number(number: &str) -> u8 {
		return number.parse::<u8>().unwrap();
	}

	for line in buf.lines() {
		if line.starts_with("workspace>>") {
			*focused = get_number(&line[11 ..]);

			changed = true;
		} else if line.starts_with("createworkspace>>") {
			workspaces.insert(get_number(&line[16 ..]));

			changed = true;
		} else if line.starts_with("destroyworkspace>>") {
			let destroyed = get_number(&line[17 ..]);

			if workspaces.contains(&destroyed) {
				workspaces.remove(&destroyed);
				changed = true;
			}
		}
	}

	return changed;
}

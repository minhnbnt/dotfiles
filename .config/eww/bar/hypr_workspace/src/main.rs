use std::collections::BTreeSet;
use std::io::{BufRead, BufReader, Read, Write};
use std::os::unix::net::UnixStream;
use std::path::PathBuf;

const OTHER_ICON: &str = "";
const ICONS: [&str; 7] = ["", "", "", "", "", "", ""];

pub fn print_workspaces(
	exec_path: &PathBuf,
	workspaces: &BTreeSet<u8>,
	focused: &u8,
) {
	let mut workspaces = workspaces.clone();

	print!("(eventbox :onscroll \"{} {{}}\" ", exec_path.display());
	print!("(box :class 'works' :orientation 'v' :space-evenly false");

	for (index, icon) in ICONS.iter().enumerate() {
		let index = index as u8 + 1;

		print!(" (button :tooltip 'Workspace {}' ", index);

		print!(":onclick 'hyprctl dispatch workspace {}' ", index);
		print!(":onrightclick 'hyprctl dispatch workspace {}' ", index);

		let class = match index {
			_ if index == *focused => "focused",
			_ if workspaces.contains(&index) => "active",
			_ => "inactive",
		};

		if workspaces.contains(&index) {
			workspaces.remove(&index);
		}

		print!(":class '{}' '{}')", class, icon);
	}

	for &index in workspaces.iter() {
		print!(" (button :tooltip 'Workspace {}'", index);

		if index == *focused {
			print!(":class 'focused' '{}')", OTHER_ICON);
			continue;
		}

		print!(":onclick 'hyprctl dispatch workspace {}' ", index);
		print!(":onrightclick 'hyprctl dispatch workspace {}' ", index);

		print!(":class 'active' '{}')", OTHER_ICON);
	}

	println!("))");
}

pub fn main() {
	let sock_dir = match std::env::var("HYPRLAND_INSTANCE_SIGNATURE") {
		Ok(path) => format!("/tmp/hypr/{}/", path),
		Err(msg) => panic!("{}", msg),
	};

	let (mut workspaces, mut focused_workspace) = init(&sock_dir);

	let exec_path: PathBuf = std::env::current_exe().unwrap();

	println!("; Connecting to: {}.socket2.sock...", sock_dir);

	let stream = UnixStream::connect(sock_dir + ".socket2.sock").unwrap();
	stream.shutdown(std::net::Shutdown::Write).unwrap();
	let mut reader = BufReader::new(stream);

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

pub fn init(sock_dir: &String) -> (BTreeSet<u8>, u8) {
	let mut workspaces: BTreeSet<u8> = BTreeSet::new();

	println!("; Connecting to: {}.socket.sock...", sock_dir);
	let mut stream = UnixStream::connect(sock_dir.clone() + ".socket.sock")
		.expect("; Error: failed to connect to server.");

	stream.write(b"j/activeworkspace").unwrap();

	let mut output = String::new();
	stream.read_to_string(&mut output).unwrap();

	let focused = json::parse(&output).unwrap()["id"].as_u8().unwrap();
	stream.shutdown(std::net::Shutdown::Both).unwrap();

	let mut stream =
		UnixStream::connect(sock_dir.clone() + ".socket.sock").unwrap();

	stream.write(b"j/workspaces").unwrap();

	let mut output = String::new();
	stream.read_to_string(&mut output).unwrap();

	for workspace in json::parse(&output).unwrap().members() {
		let id = workspace["id"].as_u8().unwrap();
		workspaces.insert(id);
	}

	return (workspaces, focused);
}

pub fn update(
	buf: String,
	workspaces: &mut BTreeSet<u8>,
	focused: &mut u8,
) -> bool {
	let mut changed = false;

	for line in buf.lines() {
		if line.starts_with("workspace>>") {
			let forcused_workspace: String = line.chars().skip(11).collect();
			*focused = forcused_workspace.parse::<u8>().unwrap();

			changed = true;
		} else if line.starts_with("createworkspace>>") {
			let created_workspace: String = line.chars().skip(16).collect();
			workspaces.insert(created_workspace.parse::<u8>().unwrap());

			changed = true;
		} else if line.starts_with("destroyworkspace>>") {
			let destroyed_workspace: String = line.chars().skip(17).collect();
			let u8_destroyed = destroyed_workspace.parse::<u8>().unwrap();

			if workspaces.contains(&u8_destroyed) {
				workspaces.remove(&u8_destroyed);

				changed = true;
			}
		}
	}

	return changed;
}

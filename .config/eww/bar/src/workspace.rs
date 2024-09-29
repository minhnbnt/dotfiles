use std::{
	collections::BTreeSet,
	env,
	error::Error,
	io::{self, BufReader, Read, Write},
	os::unix::net::UnixStream,
	path::PathBuf,
	process::{exit, Command},
};

struct Widget {
	exec_path: PathBuf,
	active_workspace: u8,
	visible_workspaces: BTreeSet<u8>,
}

impl Widget {
	pub fn print(&self) {
		const OTHER_ICON: &str = "";
		const ICONS: [&str; 7] = ["1", "2", "3", "4", "5", "6", "7"];

		print!("(eventbox :onscroll '{} {{}}' ", self.exec_path.display());
		print!("(box :class 'works' :orientation 'v' :space-evenly false");

		#[inline]
		fn print_button(index: u8, class: &str, icon: &str) {
			print!(" (button :tooltip 'Workspace {}' ", index);

			print!(":onclick 'hyprctl dispatch workspace {}' ", index);
			print!(":onrightclick 'hyprctl dispatch workspace {}' ", index);

			print!(":class '{}' '{}')", class, icon);
		}

		let mut visible = self.visible_workspaces.clone();

		for (index, icon) in ICONS.iter().enumerate() {
			let index = index as u8 + 1;

			let mut class = "inactive";

			if visible.remove(&index) {
				class = "visible";
			}

			if index == self.active_workspace {
				class = "active";
			}

			print_button(index, class, icon);
		}

		for index in visible {
			let mut class = "visible";

			if index == self.active_workspace {
				class = "active";
			}

			print_button(index, class, OTHER_ICON);
		}

		println!("))");
	}

	pub fn handle_event(&mut self, events: &str) -> Option<()> {
		let mut changed = None;

		let get_number = |buf: &str| buf.parse::<u8>().ok();

		for line in events.lines() {
			if let Some(num) = line.strip_prefix("workspace>>") {
				self.active_workspace = get_number(num)?;
				changed = Some(());

				continue;
			}

			if let Some(num) = line.strip_prefix("createworkspace>>") {
				self.visible_workspaces.insert(get_number(num)?);
				changed = Some(());

				continue;
			}

			if let Some(num) = line.strip_prefix("destroyworkspace>>") {
				let destroyed = get_number(num)?;

				if self.visible_workspaces.remove(&destroyed) {
					changed = Some(());
				}
			}
		}

		changed
	}

	pub fn new(sock_dir: &str) -> io::Result<Self> {
		#[inline]
		fn get_number(buf: &str) -> io::Result<u8> {
			buf[13 .. 15]
				.trim_end()
				.parse::<u8>()
				.map_err(|_| io::Error::other("Failed to parse int"))
		}

		let stream_path = format!("{}.socket.sock", sock_dir);

		let mut stream = UnixStream::connect(&stream_path)?;

		let mut output = String::new();
		stream.write_all(b"activeworkspace")?;
		stream.read_to_string(&mut output)?;

		let focused = get_number(&output)?;

		stream = UnixStream::connect(stream_path)?;

		output.clear();
		stream.write_all(b"workspaces")?;
		stream.read_to_string(&mut output)?;

		let visible_workspaces = output
			.lines()
			.filter(|line| line.starts_with("workspace ID"))
			.filter_map(|line| get_number(line).ok())
			.collect::<BTreeSet<u8>>();

		Ok(Self {
			visible_workspaces,
			active_workspace: focused,
			exec_path: env::current_exe()?,
		})
	}
}

pub fn main() -> Result<(), Box<dyn Error>> {
	arg_handle();

	let xdg_runtime_dir = env::var("XDG_RUNTIME_DIR")?;
	let instance_signature = env::var("HYPRLAND_INSTANCE_SIGNATURE")?;

	let sock_dir = format!("{xdg_runtime_dir}/hypr/{instance_signature}/");
	println!("; Socket directory: {}", sock_dir);

	let mut widget = Widget::new(&sock_dir)?;

	let stream_path = format!("{}.socket2.sock", sock_dir);
	let stream = UnixStream::connect(stream_path)?;
	let mut reader = BufReader::new(stream);

	widget.print();

	loop {
		let mut bytes = vec![0; 1024];

		if let Ok(0) | Err(_) = reader.read(&mut bytes) {
			continue;
		}

		let buffer = String::from_utf8_lossy(&bytes);

		if widget.handle_event(&buffer).is_some() {
			widget.print();
		}
	}
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

	if let Err(e) = command.args(args_command).spawn() {
		panic!("Failed to execute command: {}", e);
	}

	exit(0);
}

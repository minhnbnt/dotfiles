const hyprland = await Service.import('hyprland');

function getClassName(id: number) {
	if (hyprland.active.workspace.id == id) {
		return 'active';
	}

	if (hyprland.workspaces.some((ws) => ws.id === id)) {
		return 'visible';
	}

	return 'empty';
}

function dispatchWorkspace(ws: any) {
	hyprland.messageAsync(`dispatch workspace ${ws}`);
}

function getWorkspaceButton(id: number) {
	return Widget.Button({
		label: `${id}`,
		onClicked: () => dispatchWorkspace(id),
	}).hook(hyprland, (self) => (self.class_name = getClassName(id)));
}

export default function Workspaces() {
	return Widget.Box({
		vpack: 'fill',
		vertical: true,
		children: Array.from({ length: 10 }, (_, i) => i + 1) //
			.map((i) => getWorkspaceButton(i)),
	});
}

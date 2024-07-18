const battery = await Service.import('battery');

function getTooltip() {
	let result = 'Battery: ';

	if (battery.charging) {
		result += 'Charging, ';
	}

	if (battery.charged) {
		result += 'Full, ';
	}

	result += `${battery.percent}%`;

	return result;
}

export default function Battery() {
	return Widget.Button({
		child: Widget.Icon({
			icon: battery.bind('icon_name'),
		}),
	}).hook(battery, (self) => (self.tooltip_text = getTooltip()));
}

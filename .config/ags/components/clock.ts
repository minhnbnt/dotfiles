interface OutputRecord {
	hour: string;
	minute: string;
	second: string;
	tooltip: string;
}

const record = Variable<OutputRecord>({
	hour: '',
	minute: '',
	second: '',
	tooltip: '',
});

Utils.subprocess(
	'/home/minhnbnt/.config/eww/bar/bin/calendar',
	(output) => (record.value = JSON.parse(output)),
);

export default function Clock() {
	return Widget.Box({
		orientation: 1,
		tooltip_text: record.bind().as((record) => record.tooltip),
		children: [
			Widget.Label({
				label: record.bind().as((record) => record.hour),
			}),
			Widget.Label({
				label: record.bind().as((record) => record.minute),
			}),
			Widget.Label({
				label: record.bind().as((record) => record.second),
			}),
		],
	});
}

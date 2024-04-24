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
			Widget.Label().hook(
				record,
				(self) => (self.label = record.value.hour),
			),
			Widget.Label().hook(
				record,
				(self) => (self.label = record.value.minute),
			),
			Widget.Label().hook(
				record,
				(self) => (self.label = record.value.second),
			),
		],
	});
}

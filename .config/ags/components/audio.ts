const audio = await Service.import('audio');

const revealSlider = Variable(false);

export default function Audio(type = 'speaker') {
	const target = audio[type];
	const slider = Widget.Slider({
		inverted: true,
		orientation: 1,
		drawValue: false,
		onChange: ({ value }) => (target.volume = value),
		value: target.bind('volume'),
	});

	return Widget.EventBox({
		onHover: () => {
			revealSlider.setValue(true);
		},

		setup: (self) =>
			self.on('leave-notify-event', () => {
				revealSlider.setValue(false);
			}),

		child: Widget.Box({
			vertical: true,
			children: [
				Widget.Revealer({
					revealChild: revealSlider.bind(),
					child: slider,
				}),
				Widget.Button({
					onClicked: () => {
						target.isMuted = !target.isMuted;
						revealSlider.value = !target.isMuted;
					},
				}),
			],
		}),
	});
}

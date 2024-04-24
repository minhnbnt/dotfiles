const audio = await Service.import('audio');

const revealSlider = Variable(false);

export default function Audio(type = 'speaker') {
	const slider = Widget.Slider({
		orientation: 1,
		drawValue: false,
		onChange: ({ value }) => (audio[type].volume = value),
		value: audio[type].bind('volume'),
	});

	return Widget.EventBox({
		onHover: () => revealSlider.setValue(true),

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
					onClicked: () =>
						Utils.exec(
							'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle',
						),
				}),
			],
		}),
	});
}

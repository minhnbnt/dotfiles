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
					class_name: 'vol-icon',
					onClicked: () => {
						target.isMuted = !target.isMuted;
						revealSlider.value = !target.isMuted;
					},
					child: Widget.Icon({}).hook(audio.speaker, (self) => {
						const vol = audio.speaker.volume * 100;
						const icon = [
							[101, 'overamplified'],
							[67, 'high'],
							[34, 'medium'],
							[1, 'low'],
							[0, 'muted'],
						].find(([threshold]) => threshold <= vol)?.[1];

						self.icon = `audio-volume-${icon}-symbolic`;
						self.tooltip_text = `Volume ${Math.floor(vol)}%`;
					}),
				}),
			],
		}),
	});
}

const network = await Service.import('network');

function Wifi() {
	return Widget.Icon({
		icon: network.wifi.bind('icon_name'),
		tooltipText: network.wifi.bind('ssid').as((ssid) => {
			if (ssid != null) {
				return `Wifi: ${ssid}`;
			}

			return 'Wifi: Unknown';
		}),
	});
}

function Wired() {
	return Widget.Icon({
		icon: network.wired.bind('icon_name'),
	});
}

export default function Network() {
	return Widget.Stack({
		children: {
			wifi: Wifi(),
			wired: Wired(),
		},
		shown: network.bind('primary').as((p) => p || 'wifi'),
	});
}

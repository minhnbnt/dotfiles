const battery = await Service.import('battery');

const SLASH_ICON = '\uf377';
const PLUGGED_ICON = '\uf1e6';
const CHARGING_ICON = '\uf0e7';

const FULL_ICON = '\uf240';
const THREE_QUARTER_ICON = '\uf241';
const HALF_ICON = '\uf242';
const QUARTER_ICON = '\uf243';

function getIcon() {
    if (!battery.available) {
        return SLASH_ICON;
    }

    if (battery.charged) {
        return PLUGGED_ICON;
    }

    if (battery.charging) {
        return CHARGING_ICON;
    }

    if (battery.percent > 75) {
        return FULL_ICON;
    }

    if (battery.percent > 50) {
        return THREE_QUARTER_ICON;
    }

    if (battery.percent > 25) {
        return HALF_ICON;
    }

    return QUARTER_ICON;
}

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
    return Widget.Label().hook(battery, (self) => {
        self.label = getIcon();
        self.tooltip_text = getTooltip();
    });
}

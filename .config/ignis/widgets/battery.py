from bisect import bisect
from datetime import timedelta

from ignis.services.upower import UPowerService, UPowerDevice
from ignis.widgets import Widget

LEVELS = (0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)


def get_tooltip(device: UPowerDevice) -> str:
    time_remaining = timedelta(seconds=device.time_remaining)  # type: ignore
    state: int = device.proxy.State  # type: ignore

    tooltip = (
        f"{device.kind}: "
        f"{device.energy}/{device.energy_full}mWh "
        f"({device.percent:.0f}%)"
    )

    if time_remaining.total_seconds() > 0:
        tooltip += f" [{time_remaining} remaining]"

    if state == 1:
        tooltip += " [charging]"

    if state == 4:
        tooltip += " [charged]"

    return tooltip


def get_icon(battery_device: UPowerDevice) -> str:
    state: int = battery_device.proxy.State  # type: ignore
    if state == 4:
        return "battery-level-100-charged-symbolic"

    percent: float = battery_device.percent  # type: ignore
    if percent > 100:
        percent = 100

    index = bisect(LEVELS, round(percent))
    level = LEVELS[index - 1]

    icon_name = f"battery-level-{level}"
    if state == 1:
        icon_name += "-charging"

    return icon_name + "-symbolic"


def battery() -> Widget:
    service = UPowerService.get_default()
    battery_device: UPowerDevice = service.display_device  # type: ignore

    icon_name = battery_device.bind(
        "charged",
        lambda _: battery_device.bind(
            "percent",
            lambda _: get_icon(battery_device),
        ),
    )

    widget = Widget.EventBox(
        child=[
            Widget.Icon(
                css_classes=("battery",),
                image=icon_name,
                pixel_size=22,
            )
        ]
    )

    def on_hover(_):
        widget.tooltip_text = get_tooltip(battery_device)

    # refresh tooltip_text on hover only to reduce power
    widget.on_hover = on_hover  # type: ignore

    return Widget.Box(halign="center", child=[widget])

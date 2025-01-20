from bisect import bisect
from datetime import timedelta

from ignis.services.upower import UPowerService, UPowerDevice
from ignis.widgets import Widget

from utils.binds import bind_properties

LEVELS = (0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)


def get_tooltip(device: UPowerDevice) -> str:
    time_remaining = timedelta(seconds=device.time_remaining)  # type: ignore
    state: int = device.proxy.State  # type: ignore

    tooltip = (
        f"{device.kind}: "
        f"{device.energy}/{device.energy_full}mWh "
        f"({device.percent:.0f}%)"
    )

    if state == 1:
        tooltip += " [charging]"

    elif state == 4:
        tooltip += " [charged]"

    if time_remaining.total_seconds() > 0:
        tooltip += f" [{time_remaining} remaining]"

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
    battery: UPowerDevice = service.display_device  # type: ignore

    icon_name = bind_properties(
        target=battery,
        props=("charged", "percent"),
        transform=get_icon,
    )

    return Widget.EventBox(
        child=[
            Widget.Icon(
                css_classes=("battery",),
                image=icon_name,
                pixel_size=22,
            )
        ],
        on_hover=lambda self: self.set_tooltip_text(get_tooltip(battery)),
    )

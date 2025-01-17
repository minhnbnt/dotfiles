from ignis.services.backlight import (
    BacklightService,
    BacklightDevice,
)
from ignis.widgets import Widget

from components.revealer import revealer


def get_percent(device: BacklightDevice) -> int:
    return round(device.brightness / device.max_brightness * 100)  # noqa


def on_slider_change(device: BacklightDevice, new_brightness: int) -> None:
    device.brightness = new_brightness


def get_tooltip(device: BacklightDevice) -> str:
    percent = get_percent(device)
    return (
        f"{device.device_name}: "
        f"{device.brightness}/{device.max_brightness} "  # noqa
        f"({percent}%)"
    )


def brightness_slider() -> Widget:
    service = BacklightService.get_default()
    device: BacklightDevice = service.devices[0]  # type: ignore

    component, _ = revealer(
        head=Widget.Icon(
            image="display-brightness-symbolic",
            css_classes=("slider-icon", "brightness-icon"),
            pixel_size=22,
        ),
        tooltip=device.bind("brightness", lambda _: get_tooltip(device)),
        child=Widget.Scale(
            vertical=True,
            inverted=True,
            min=device.max_brightness * 0.01,  # type: ignore
            max=device.max_brightness,
            step=1,
            css_classes=("slider", "brightness-slider"),
            value=device.bind("brightness"),
            on_change=lambda e: on_slider_change(device, round(e.value)),
        ),
    )

    return component

import os

from ignis.app import IgnisApp
from ignis.widgets import Widget
from ignis.services.system_tray import SystemTrayService

from widgets import (
    battery,
    brightness_slider,
    clock,
    power_menu,
    speaker_slider,
    workspaces,
)


def top() -> Widget:
    return workspaces()


def tray_item(item) -> Widget.Button:
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return Widget.Button(
        child=Widget.Box(
            child=[
                Widget.Icon(image=item.bind("icon"), pixel_size=24),
                menu,
            ]
        ),
        setup=lambda self: item.connect("removed", lambda x: self.unparent()),
        tooltip_text=item.bind("tooltip"),
        on_click=lambda x: menu.popup() if menu else None,
        on_right_click=lambda x: menu.popup() if menu else None,
        css_classes=["tray-item"],
    )


def tray():
    system_tray = SystemTrayService.get_default()

    return Widget.Box(
        setup=lambda self: system_tray.connect(
            "added", lambda x, item: self.append(tray_item(item))
        ),
        spacing=10,
    )


def bottom() -> Widget:
    return Widget.Box(
        vertical=True,
        child=(
            speaker_slider(),
            brightness_slider(),
            battery(),
            clock(),
            power_menu(),
        ),
    )


def bar(monitor_id: int = 0) -> Widget.Window:
    return Widget.Window(
        namespace=f"ignis_bar_{monitor_id}",
        monitor=monitor_id,
        anchor=("top", "left", "bottom"),  # type: ignore
        exclusivity="exclusive",
        style="background-color: transparent",
        child=Widget.CenterBox(
            css_classes=("bar",),
            vertical=True,
            start_widget=top(),
            end_widget=bottom(),
        ),
    )


app = IgnisApp.get_default()
app.apply_css(os.path.expanduser("~/.config/ignis/style.scss"))

bar()

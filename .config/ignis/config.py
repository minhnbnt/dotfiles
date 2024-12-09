import os

from ignis.app import IgnisApp
from ignis.widgets import Widget

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
        child=Widget.CenterBox(
            vertical=True,
            css_classes=("bar",),
            start_widget=top(),
            end_widget=bottom(),
        ),
    )


app = IgnisApp.get_default()
app.apply_css(os.path.expanduser("~/.config/ignis/style.scss"))

bar()

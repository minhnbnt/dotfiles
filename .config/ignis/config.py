from ignis.app import IgnisApp
from ignis.utils import Utils
from ignis.widgets import Widget

from widgets import (
    brightness_slider,
    clock,
    power_menu,
    battery,
    speaker_slider,
    workspaces,
)

app = IgnisApp.get_default()

app.apply_css(Utils.get_current_dir() + "/style.scss")


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


bar()

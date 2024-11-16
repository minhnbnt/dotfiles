from ignis.app import IgnisApp
from ignis.utils import Utils
from ignis.widgets import Widget

from widgets.blacklight import brightness_slider
from widgets.clock import clock_component
from widgets.volume import speaker_volume
from widgets.workspaces import workspaces
from widgets.powermenu import power_menu

app = IgnisApp.get_default()

app.apply_css(Utils.get_current_dir() + "/style.scss")


def left() -> Widget.Box:
    return Widget.Box(child=[workspaces()], spacing=10)


def right() -> Widget.Box:
    return Widget.Box(
        vertical=True,
        spacing=5,
        child=(
            speaker_volume(),
            brightness_slider(),
            clock_component(),
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
            css_classes=["bar"],
            start_widget=left(),
            end_widget=right(),
        ),
    )


for i in range(Utils.get_n_monitors()):
    bar(i)

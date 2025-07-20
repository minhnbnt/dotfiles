import os

from ignis import widgets, utils
from ignis.css_manager import CssManager, CssInfoPath
from ignis.services.system_tray import SystemTrayService

from widgets import (
    battery,
    brightness_slider,
    clock,
    power_menu,
    speaker_slider,
    workspaces,
)


def top() -> widgets.Widget:
    return workspaces()


def tray_item(item) -> widgets.Button:
    if item.menu:
        menu = item.menu.copy()
    else:
        menu = None

    return widgets.Button(
        child=widgets.Box(
            child=[
                widgets.Icon(image=item.bind("icon"), pixel_size=24),
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

    return widgets.Box(
        setup=lambda self: system_tray.connect(
            "added", lambda x, item: self.append(tray_item(item))
        ),
        spacing=10,
    )


def bottom() -> widgets.Widget:
    return widgets.Box(
        vertical=True,
        child=(
            speaker_slider(),
            brightness_slider(),
            battery(),
            clock(),
            power_menu(),
        ),
    )


def bar(monitor_id: int = 0) -> widgets.Window:
    return widgets.Window(
        namespace=f"ignis_bar_{monitor_id}",
        monitor=monitor_id,
        anchor=("top", "left", "bottom"),  # type: ignore
        exclusivity="exclusive",
        style="background-color: transparent",
        child=widgets.CenterBox(
            css_classes=("bar",),
            vertical=True,
            start_widget=top(),
            end_widget=bottom(),
        ),
    )


css_manager = CssManager.get_default()
css_manager.apply_css(
    CssInfoPath(
        name="main",
        path=os.path.expanduser("~/.config/ignis/style.scss"),
        compiler_function=lambda path: utils.sass_compile(path),
    )
)

bar()

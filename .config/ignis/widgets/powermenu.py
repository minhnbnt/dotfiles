import os
import subprocess
from typing import Callable, List, Tuple

from ignis.widgets import Widget
from ignis.variable import Variable

DIALOG_PATH = os.environ["HOME"] + "/.config/eww/bar/bin/eww_power_dialog"


def open_dialog(title: str, message: str, command: str):
    subprocess.call((DIALOG_PATH, "-t", title, "-m", message, "-c", command))


def get_button(
    image: str,
    tooltip: str,
    classes: List[str] = [],
    on_click: Callable = lambda: None,
):
    classes.append("power-button")

    return Widget.Button(
        child=Widget.Icon(
            css_classes=tuple(classes),
            image=image,
            pixel_size=22,
            tooltip_text=tooltip,
        ),
        on_click=lambda _: on_click(),
    )


def power_menu() -> Widget:
    spacing = 10

    is_hovered = Variable(value=False)

    def on_hover(_):
        is_hovered.value = True

    def on_hover_lost(_):
        is_hovered.value = False

    child = Widget.Box(
        spacing=spacing,
        vertical=True,
        child=(
            # get_button(image="system-lock-screen-symbolic", tooltip="Lock"),
            get_button(
                image="system-log-out",
                tooltip="Exit",
                classes=["exit"],
                on_click=lambda: open_dialog(
                    title="Are you sure?",
                    message="Do you really want to exit Hyprland?",
                    command="hyprctl dispatch exit --",
                ),
            ),
            get_button(
                image="system-reboot",
                tooltip="Restart",
                classes=["restart"],
                on_click=lambda: open_dialog(
                    title="Are you sure?",
                    message="Do you really want to restart?",
                    command="reboot",
                ),
            ),
        ),
    )

    def get_css_class(hover: bool) -> Tuple:
        return ("power-button", "shutdown" if hover else "shutdown-alt")

    head = Widget.Button(
        child=Widget.Icon(
            css_classes=is_hovered.bind("value", get_css_class),
            image="system-shutdown",
            pixel_size=22,
            tooltip_text="Shutdown",
        ),
        on_click=lambda _: open_dialog(
            title="Are you sure?",
            message="Do you really want to shutdown?",
            command="shutdown -P now",
        ),
    )

    revealer = Widget.Revealer(
        child=child,
        reveal_child=is_hovered.bind("value"),
        transition_type="slide_up",
        transition_duration=500,
    )

    event_box = Widget.EventBox(
        child=[revealer, head],
        css_classes=["power-menu"],
        spacing=is_hovered.bind("value", lambda hover: spacing if hover else 0),
        vertical=True,
    )

    event_box.on_hover = on_hover
    event_box.on_hover_lost = on_hover_lost

    return event_box

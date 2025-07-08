import subprocess
from collections.abc import Callable, Iterable
from typing import Optional

from ignis.widgets import Widget

from components.revealer import revealer
from gi.repository import Gtk, Gio  # type: ignore


class DialogProvider:
    def __init__(self) -> None:
        self._context = None

    def open_dialog(self, title: str, message: str, command: list[str]):
        if self._context is not None:
            self._context.cancel()

        self._context = Gio.Cancellable.new()

        dialog = Gtk.AlertDialog(
            modal=True,
            buttons=["No", "Yes"],
        )

        dialog.set_cancel_button(0)

        dialog.set_modal(False)
        dialog.set_message(title)
        dialog.set_detail(message)

        def callback(source, result):
            try:
                index = source.choose_finish(result)
            except Exception:
                return

            clicked_yes = index == 1

            if clicked_yes:
                subprocess.call(command)

        dialog.choose(
            callback=callback,
            cancellable=self._context,
        )


def get_button(
    image: str,
    tooltip: str,
    classes: Optional[Iterable[str]] = None,
    on_click: Callable = lambda: None,
):
    if classes is None:
        classes = []

    return Widget.Button(
        child=Widget.Icon(
            css_classes=(*classes, "power-button"),
            image=image,
            pixel_size=22,
            tooltip_text=tooltip,
        ),
        on_click=lambda _: on_click(),
    )


def power_menu() -> Widget:
    spacing = 10
    dialog_provider = DialogProvider()
    open_dialog = dialog_provider.open_dialog

    child = Widget.Box(
        spacing=spacing,
        vertical=True,
        child=(
            get_button(
                image="system-log-out-symbolic",
                tooltip="Exit",
                classes=["exit"],
                on_click=lambda: open_dialog(
                    title="Are you sure?",
                    message="Do you really want to exit Hyprland?",
                    command=["hyprctl", "dispatch", "exit", "--"],
                ),
            ),
            get_button(
                image="system-reboot-symbolic",
                tooltip="Restart",
                classes=["restart"],
                on_click=lambda: open_dialog(
                    title="Are you sure?",
                    message="Do you really want to restart?",
                    command=["reboot"],
                ),
            ),
        ),
    )

    def get_head_css_class(hover: bool) -> tuple[str, str]:
        return "power-button", "shutdown" if hover else "shutdown-alt"

    head = Widget.Button(
        child=Widget.Icon(
            image="system-shutdown-symbolic",
            pixel_size=22,
            tooltip_text="Shutdown",
        ),
        on_click=lambda _: open_dialog(
            title="Are you sure?",
            message="Do you really want to shutdown?",
            command=["shutdown", "-P", "now"],
        ),
    )

    component, revealed_child = revealer(
        head,
        child,
        spacing,
        css_classes=["power-menu"],
    )

    head.css_classes = revealed_child.bind("value", get_head_css_class)

    return component

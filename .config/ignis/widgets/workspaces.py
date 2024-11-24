from typing import Literal, Iterable

from ignis.services.hyprland import HyprlandService
from ignis.widgets import Widget

hyprland = HyprlandService.get_default()
ICONS = ("1", "2", "3", "4", "5", "6", "7")


def scroll_workspaces(direction: Literal["up", "down"]) -> None:
    current = hyprland.active_workspace["id"]  # type: ignore

    target = current + 1
    if direction == "up":
        target = current - 1

    if 1 <= target <= 10:
        hyprland.switch_to_workspace(target)


def get_buttons(workspaces: Iterable[dict]) -> Iterable[Widget]:
    visible_workspaces = {workspace["id"] for workspace in workspaces}
    active_workspace_id = hyprland.active_workspace["id"]  # type: ignore

    buttons = {
        "before-active": [],
        "after-active": [],
        "active": None,
    }

    def add_button(id: int, button: Widget.Button):
        if id > active_workspace_id:
            buttons["after-active"].append(button)
        elif id < active_workspace_id:
            buttons["before-active"].append(button)

        else:
            buttons["active"] = button

    def get_button(id: int, label: str) -> Widget.Button:
        return Widget.Button(
            css_classes=("workspace-button",),
            child=Widget.Label(label=label),
            on_click=lambda _: hyprland.switch_to_workspace(id),
        )

    for id, icon in enumerate(ICONS, start=1):
        button = get_button(id, icon)

        class_name = "hidden"

        if id in visible_workspaces:
            visible_workspaces.discard(id)
            class_name = "visible"

        if id == active_workspace_id:
            class_name = "active"

        button.add_css_class(class_name)
        add_button(id, button)

    for id in sorted(visible_workspaces):
        label = str(id)
        if id == 10:
            label = "0"

        button = get_button(id, label)

        if id == active_workspace_id:
            button.add_css_class("active")

        add_button(id, button)

    return (
        Widget.Box(
            vertical=True,
            css_classes=("not-visible",),
            child=(
                Widget.Box(
                    vertical=True,
                    css_classes=("before-active",),
                    child=iter(buttons["before-active"]),
                ),
            ),
        ),
        buttons["active"],
        Widget.Box(
            vertical=True,
            css_classes=("not-visible",),
            child=(
                Widget.Box(
                    vertical=True,
                    css_classes=("after-active",),
                    child=iter(buttons["after-active"]),
                ),
            ),
        ),
    )


def workspaces() -> Widget.EventBox:
    return Widget.EventBox(
        on_scroll_up=lambda _: scroll_workspaces("up"),
        on_scroll_down=lambda _: scroll_workspaces("down"),
        css_classes=("workspaces",),
        vertical=True,
        child=hyprland.bind("workspaces", get_buttons),
    )

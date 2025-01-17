from collections.abc import Iterable
from typing import Literal, FrozenSet

from ignis.services.hyprland import HyprlandService
from ignis.widgets import Widget

from services.hyprland import derived_workspace_status

hyprland = HyprlandService.get_default()

ICONS = ("1", "2", "3", "4", "5", "6")
ICONS_LENGTH = len(ICONS)


def get_button_label(id: int) -> str:
    if id == 10:
        return "0"

    if id <= len(ICONS):
        return ICONS[id - 1]

    return f"{id}"


def get_button(id: int, label: str) -> Widget.Button:
    def get_css_classes(workspaces: FrozenSet[int], active: int) -> Iterable[str]:
        css_classes = ["workspace-button"]

        if id in workspaces:
            css_classes.append("has-windows")

        elif id <= ICONS_LENGTH:
            css_classes.append("visible")

        else:
            css_classes.append("hidden")

        if id == active:
            css_classes.append("active")

        return css_classes

    return Widget.Button(
        child=Widget.Label(label=label),
        tooltip_text=f"Workspace {label}",
        on_click=lambda _: hyprland.switch_to_workspace(id),
        css_classes=derived_workspace_status(get_css_classes),
    )


def background() -> Widget:
    def get_boxes(workspaces: FrozenSet[int], active: int) -> str:
        number_of_boxes = active - 1

        if active > ICONS_LENGTH:
            number_of_boxes = (
                sum(1 for id in workspaces if ICONS_LENGTH < id < active)  #
                + ICONS_LENGTH
            )

        margin = 36 * number_of_boxes + 2

        return f"margin-top: {margin}px;"

    return Widget.Box(
        child=(Widget.Label(label=" "),),
        style=derived_workspace_status(get_boxes),
        css_classes=("active", "workspaces-background"),
    )


def scroll_workspaces(direction: Literal["up", "down"]) -> None:
    current = hyprland.active_workspace["id"]  # type: ignore

    target = current + 1
    if direction == "up":
        target = current - 1

    if 1 <= target <= 10:
        hyprland.switch_to_workspace(target)


def workspaces() -> Widget:
    return Widget.Overlay(
        child=background(),
        css_classes=("workspaces",),
        overlays=(
            Widget.EventBox(
                vertical=True,
                on_scroll_up=lambda _: scroll_workspaces("up"),
                on_scroll_down=lambda _: scroll_workspaces("down"),
                child=(get_button(id, get_button_label(id)) for id in range(1, 11)),
            ),
        ),
    )

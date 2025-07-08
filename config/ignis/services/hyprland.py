from collections.abc import Callable
from typing import Any

from ignis.services.hyprland import HyprlandService

from utils.derived import derived_variable


def _get_workspaces_has_window(hyprland: HyprlandService) -> frozenset[int]:
    return frozenset(workspace.id for workspace in hyprland.workspaces)  # noqa


class HyprlandWorkspacesService:
    def __init__(self, hyprland: HyprlandService) -> None:
        self.hyprland = hyprland
        self.workspaces = derived_variable(
            hyprland,
            "workspaces",
            _get_workspaces_has_window,
        )

    def derived_workspace_status(self, f: Callable[[frozenset[int], int], Any]):
        return self.workspaces.bind(
            "value",
            lambda workspaces: self.hyprland.bind(
                "active_workspace",
                lambda active: f(workspaces, active.id),
            ),
        )


hyprland = HyprlandService.get_default()
_instance = HyprlandWorkspacesService(hyprland)

derived_workspace_status = _instance.derived_workspace_status

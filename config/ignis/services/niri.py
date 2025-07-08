from typing import Any, Callable
from ignis.services.niri import NiriService

from utils.derived import derived_variable


def _get_workspaces_has_window(niri: NiriService) -> frozenset[int]:
    return frozenset(workspace.idx for workspace in niri.workspaces)  # noqa


class NiriWorkspaceService:
    def __init__(self, niri: NiriService) -> None:
        self.niri = niri
        self.workspaces = derived_variable(
            niri,
            "workspaces",
            _get_workspaces_has_window,
        )

    def derived_workspace_status(self, f: Callable[[frozenset[int], int], Any]):
        return self.workspaces.bind(
            "value",
            lambda workspaces: f(workspaces, 1),
        )


niri = NiriService.get_default()
_instance = NiriWorkspaceService(niri)

derived_workspace_status = _instance.derived_workspace_status

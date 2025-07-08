from time import sleep
from ignis.services.niri import NiriService, NiriWorkspace
from ignis.widgets import Widget
from ignis.utils.thread import run_in_thread

niri = NiriService.get_default()


def get_css_classes(idx: int, is_focused: bool) -> list[str]:
    result = ["workspace-button"]

    if idx < len(niri.workspaces):
        result.append("has-windows")

    if is_focused:
        result.append("active")

    return result


cache = dict()


def get_button(id: int) -> Widget.Button | None:
    button = cache.get(id)
    if button is not None:
        return button

    workspace = niri.get_workspace_by_id(id)
    if workspace is None:
        return None

    button = Widget.Button(
        child=Widget.Label(label=workspace.bind("idx", str)),
        tooltip_text=workspace.bind("idx", lambda idx: f"Workspace {idx}"),
        on_click=lambda _: workspace.switch_to(),
        css_classes=workspace.bind_many(["idx", "is_focused"], get_css_classes),
        valign="center",
    )

    cache[id] = button

    # @run_in_thread
    # def refresh_css_class(_, __):
    #     sleep(0.01)
    #
    #     if workspace.idx >= len(niri.workspaces):
    #         button.css_classes = ["workspace-button"]
    #     else:
    #         button.css_classes = get_css_classes(workspace.idx, workspace.is_focused)
    #
    # niri.connect("notify::workspaces", refresh_css_class)
    #
    # @run_in_thread
    # def on_destroy(_):
    #     sleep(0.01)
    #     button.css_classes = ["workspace-button", "hidden"]
    #     del cache[id]
    #
    # workspace.connect("destroyed", on_destroy)

    return button


def get_overlay() -> Widget:
    def get_margin(workspaces: NiriWorkspace):
        active_idx = [
            workspace.idx
            for workspace in workspaces  #
            if workspace.is_focused
        ]

        if not active_idx:
            return

        margin = 2 + 38 * (active_idx[0] - 1)
        return f"margin-top: {margin}px;"

    return Widget.Box(
        style=niri.bind("workspaces", lambda workspaces: get_margin(workspaces)),
        css_classes=("active", "workspaces-background"),
    )


def workspaces() -> Widget:
    v1 = niri.bind(
        "workspaces",
        lambda workspaces: (get_button(workspace.id) for workspace in workspaces),
    )

    buttons = Widget.EventBox(vertical=True, child=v1)

    return Widget.Overlay(
        css_classes=("workspaces",),
        valign="center",
        overlays=(
            get_overlay(),
            buttons,
        ),
    )

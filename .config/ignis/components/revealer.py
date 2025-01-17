from collections.abc import Iterable
from typing import Optional, Tuple

from ignis.variable import Variable
from ignis.widgets import Widget

from utils.debounce import DebounceWorker

_TIMEOUT_SECONDS = 1
_var_setters = []


def _add_event(
    event_box: Widget.EventBox,
    revealer: Widget.Revealer,
    reveal_child: Variable,
    spacing: int,
) -> None:
    worker = DebounceWorker()

    def set_reveal_child(value: bool, timeout_second: float = 0):
        worker.run(
            round(timeout_second * 1000),
            lambda: setattr(reveal_child, "value", value),
        )

    _var_setters.append(set_reveal_child)

    def on_hover(_) -> None:
        for setter in _var_setters:
            setter(False)

        set_reveal_child(True)

    event_box.on_hover = on_hover  # type: ignore
    event_box.on_hover_lost = lambda _: set_reveal_child(False, _TIMEOUT_SECONDS)  # type: ignore

    def on_reveal_child_change(is_revealed: Variable, _):
        if is_revealed.value:  # noqa
            revealer.reveal_child = True
            event_box.spacing = spacing

        else:
            revealer.reveal_child = False
            event_box.spacing = 0

    reveal_child.connect("notify::value", on_reveal_child_change)


def revealer(
    head: Widget,
    child: Widget,
    spacing: int = 0,
    tooltip: Optional[str] = None,
    css_classes: Optional[Iterable[str]] = None,
) -> Tuple[Widget.EventBox, Variable]:
    if css_classes is None:
        css_classes = []

    revealer = Widget.Revealer(
        child=child,
        transition_type="slide_up",
        transition_duration=500,
    )

    event_box = Widget.EventBox(
        css_classes=("container", *css_classes),
        child=(revealer, head),
        vertical=True,
        spacing=0,
    )

    if tooltip is not None:
        event_box.tooltip_text = tooltip

    reveal_child = Variable(value=False)

    _add_event(event_box, revealer, reveal_child, spacing)

    return event_box, reveal_child

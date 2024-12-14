from typing import Iterable, Optional, Tuple

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
        def setter() -> None:
            reveal_child.value = value

        worker.run(round(timeout_second * 1000), setter)

    _var_setters.append(set_reveal_child)

    def on_hover() -> None:
        for setter in _var_setters:
            if setter is not set_reveal_child:
                setter(False)

        set_reveal_child(True)

    event_box.on_hover = lambda _: on_hover()
    event_box.on_hover_lost = lambda _: set_reveal_child(False, _TIMEOUT_SECONDS)

    def on_reveal_child_change(is_revealed: Variable, _):
        if is_revealed.value:  # noqa
            revealer.reveal_child = True
            event_box.spacing = spacing

        else:
            revealer.reveal_child = False
            event_box.spacing = 0

    reveal_child.connect("notify::value", on_reveal_child_change)


def revealer(
    child: Widget,
    head: Widget,
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
        spacing=0,
        vertical=True,
    )

    reveal_child = Variable(value=False)

    _add_event(event_box, revealer, reveal_child, spacing)

    if tooltip is not None:
        event_box.tooltip_text = tooltip

    return event_box, reveal_child

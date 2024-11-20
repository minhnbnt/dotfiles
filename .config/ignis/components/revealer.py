from typing import List, Optional, Tuple

from ignis.variable import Variable
from ignis.widgets import Widget


def revealer_when_hover(
    child: Widget,
    head: Widget,
    spacing: int = 0,
    tooltip: Optional[str] = None,
    css_classes: Optional[List[str]] = None,
) -> Tuple[Widget, Variable]:
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

    def on_reveal_child_change(is_revealed: Variable, _):
        if is_revealed.value:
            revealer.set_reveal_child(True)
            event_box.set_property("spacing", spacing)

        else:
            revealer.set_reveal_child(False)
            event_box.set_property("spacing", 0)

    reveal_child.connect("notify::value", on_reveal_child_change)

    event_box.on_hover = lambda _: reveal_child.set_property("value", True)
    event_box.on_hover_lost = lambda _: reveal_child.set_property("value", False)

    if tooltip is not None:
        event_box.set_property("tooltip_text", tooltip)

    return event_box, reveal_child

from typing import Optional

from ignis.widgets import Widget


def revealer_when_hover(
    child: Widget,
    head: Widget,
    spacing: int = 0,
    tooltip: Optional[str] = None,
) -> Widget.EventBox:
    revealer = Widget.Revealer(
        child=child,
        transition_type="slide_up",
        transition_duration=500,
    )

    event_box = Widget.EventBox(
        child=(revealer, head),
        spacing=0,
        vertical=True,
    )

    def on_hover(_):
        revealer.set_reveal_child(True)
        event_box.set_property("spacing", spacing)

    def on_hover_lost(_):
        revealer.set_reveal_child(False)
        event_box.set_property("spacing", 0)

    event_box.on_hover = on_hover
    event_box.on_hover_lost = on_hover_lost

    if tooltip is not None:
        event_box.set_property("tooltip_text", tooltip)

    return event_box

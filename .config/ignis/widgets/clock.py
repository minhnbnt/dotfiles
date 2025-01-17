from collections.abc import Callable
from datetime import datetime

from ignis.utils.poll import Poll
from ignis.widgets import Widget

_clock = Poll(1000, lambda _: datetime.now())


def transform(func: Callable[[datetime], str]):
    return _clock.bind("output", func)


def clock() -> Widget.Box:
    return Widget.Box(
        vertical=True,
        halign="center",
        css_classes=("clock",),
        child=(
            Widget.Label(label=transform(lambda t: f"{t.hour:02d}")),
            Widget.Label(label=transform(lambda t: f"{t.minute:02d}")),
            Widget.Label(label=transform(lambda t: f"{t.second:02d}")),
        ),
        tooltip_text=transform(lambda t: t.strftime("%A, %B %d %Y %H:%M:%S")),
    )

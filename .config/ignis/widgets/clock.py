from datetime import datetime
from typing import Callable

from ignis.utils import Utils
from ignis.widgets import Widget

_clock = Utils.Poll(1000, lambda _: datetime.now())


def transform(func: Callable[[datetime], str]):
    return _clock.bind("output", func)


def clock_component() -> Widget.Box:
    return Widget.Box(
        vertical=True,
        css_classes=["clock"],
        child=(
            Widget.Label(label=transform(lambda t: f"{t.hour:02d}")),
            Widget.Label(label=transform(lambda t: f"{t.minute:02d}")),
            Widget.Label(label=transform(lambda t: f"{t.second:02d}")),
        ),
        tooltip_text=transform(lambda t: t.strftime("%a, %b %d %Y %H:%M:%S")),
    )

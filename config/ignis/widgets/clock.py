from collections.abc import Callable
from datetime import datetime, timedelta
import time

from ignis.utils.poll import Poll
from ignis.widgets import Widget


def get_uptime() -> timedelta:
    uptime_second = time.clock_gettime(time.CLOCK_BOOTTIME)
    uptime_second = round(uptime_second)

    return timedelta(seconds=uptime_second)


_clock = Poll(1000, lambda _: (datetime.now(), get_uptime()))


def transform_datetime(func: Callable[[datetime, timedelta], str]):
    return _clock.bind("output", lambda t: func(*t))


def get_tooltip(time: datetime, uptime: timedelta) -> str:
    return f"Uptime: {uptime}\n{time:%A, %B %d %Y %H:%M:%S}"


def clock() -> Widget.Box:
    return Widget.Box(
        vertical=True,
        halign="center",
        css_classes=("clock",),
        tooltip_text=transform_datetime(get_tooltip),
        child=(
            Widget.Label(label=transform_datetime(lambda t, _: f"{t:%H}")),
            Widget.Label(label=transform_datetime(lambda t, _: f"{t:%M}")),
            Widget.Label(label=transform_datetime(lambda t, _: f"{t:%S}")),
        ),
    )

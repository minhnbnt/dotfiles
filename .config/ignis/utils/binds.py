from collections.abc import Iterable, Callable
from typing import Any

from ignis.gobject import IgnisGObject


def bind_properties[T: IgnisGObject](
    target: T,
    props: Iterable[str],
    transform: Callable[[T], Any],
):
    props = tuple(props)
    assert len(props) > 0, "props should not be empty."

    result = target.bind(props[0], lambda _: transform(target))
    for prop in props[1:]:
        prev = result
        result = target.bind(prop, lambda _: prev)

    return result

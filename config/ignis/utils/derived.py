from typing import Callable, Any

from ignis.gobject import IgnisGObject
from ignis.variable import Variable


def derived_variable(
    target: IgnisGObject,
    property_name: str,
    transform: Callable[[IgnisGObject], Any],
) -> Variable:
    result = Variable(value=transform(target))

    target.connect(
        f"notify::{property_name}",
        lambda _, __: setattr(result, "value", transform(target)),
    )

    return result

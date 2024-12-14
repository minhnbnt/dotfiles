from typing import Callable

from ignis.utils.timeout import Timeout


class DebounceWorker:
    def __init__(self) -> None:
        self._timer = Timeout(0, lambda: None)

    def run(self, ms: int, func: Callable) -> None:
        self._timer.cancel()
        self._timer = Timeout(ms, func)

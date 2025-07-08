import os
import subprocess
from pathlib import Path

from ignis.services.hyprland import HyprlandService
from ignis.variable import Variable

TEMPERATURE = 5000


class Hyprsunset:
    def __init__(self, hyprland: HyprlandService, cache_location: Path) -> None:
        self.process = None
        self.cache_file = cache_location

        self._hyprland = hyprland

        is_enabled = False
        self.is_enabled = Variable(is_enabled)

    def _check_if_active(self) -> bool:
        if not self.cache_file.is_file():
            return False

        return self.cache_file.read_text() == "1"

    def _set_active_status(self, status: bool):
        self._on_active_change(status)

        self.is_enabled = status
        self.cache_file.write_text("1" if status else "0")

    def _on_active_change(self, active: bool):
        if not self._hyprland.is_available:
            return

        command = ["hyprctl", "hyprsunset"]

        if active:
            command += ["temperature", "5000"]
        else:
            command += ["identity"]

        subprocess.call(command)

    def toggle(self) -> None:
        self._set_active_status(not self.is_enabled)


CACHE_FILE_LOCATION = os.path.expanduser("~/.cache/hyprsunset")
cache_path = Path(CACHE_FILE_LOCATION)

_hyprland = HyprlandService.get_default()
_instance = Hyprsunset(_hyprland, cache_path)

toggle_hypr_sunset = _instance.toggle
is_enabled = _instance.is_enabled

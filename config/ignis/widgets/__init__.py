from ignis.widgets import Widget
from ignis.services.niri import NiriService

from .battery import battery
from .backlight import brightness_slider
from .clock import clock
from .powermenu import power_menu
from .volume import speaker_slider


def workspaces() -> Widget:
    niri = NiriService.get_default()

    if niri.is_available:
        from .workspaces_niri import workspaces as niri_workspace

        return niri_workspace()

    else:
        from .workspaces import workspaces as hyprland_workspace

        return hyprland_workspace()

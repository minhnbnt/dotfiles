from ignis.services.audio import AudioService, Stream
from ignis.widgets import Widget

from components.revealer import revealer


def speaker_volume() -> Widget:
    audio = AudioService.get_default()
    stream = audio.speaker

    def toggle_mute(_) -> None:
        stream.is_muted = not stream.is_muted

    def get_tooltip(stream: Stream) -> str:
        result = f"{stream.name}: {stream.volume}%"
        if stream.is_muted:
            result += " [MUTED]"

        return result

    slider = Widget.Scale(
        vertical=True,
        inverted=True,
        min=0,
        max=100,
        step=1,
        css_classes=("slider", "volume-slider"),
        value=stream.bind("volume"),
        on_change=lambda e: stream.set_volume(e.value),
    )

    button = Widget.Button(
        child=Widget.Icon(
            css_classes=["slider-icon", "volume-icon"],
            image=stream.bind("icon_name"),
            pixel_size=22,
        ),
        on_click=toggle_mute,
    )

    component, _ = revealer(
        child=slider,
        head=button,
        tooltip=stream.bind(
            "is_muted",
            lambda _: stream.bind(
                "volume",
                lambda _: get_tooltip(stream),
            ),
        ),
    )

    return component

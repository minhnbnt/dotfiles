from ignis.services.audio import AudioService, Stream
from ignis.widgets import Widget

from components.revealer import revealer
from utils.binds import bind_properties


def get_tooltip(audio_stream: Stream) -> str:
    result = f"{audio_stream.name}: {audio_stream.volume}%"  # noqa
    if audio_stream.is_muted:  # noqa
        result += " [MUTED]"

    return result


def on_slider_change(stream: Stream, value: int) -> None:
    stream.is_muted = False  # type: ignore
    stream.set_volume(value)


def speaker_slider() -> Widget:
    audio = AudioService.get_default()
    stream = audio.speaker  # noqa

    def toggle_mute(_) -> None:
        stream.is_muted = not stream.is_muted

    slider = Widget.Scale(
        vertical=True,
        inverted=True,
        min=0,
        max=100,
        step=1,
        css_classes=("slider", "volume-slider"),
        value=stream.bind("volume"),
        on_change=lambda e: on_slider_change(stream, e.value),
    )

    button = Widget.Button(
        child=Widget.Icon(
            css_classes=("slider-icon", "volume-icon"),
            image=stream.bind("icon_name"),
            pixel_size=22,
        ),
        on_click=toggle_mute,
    )

    tooltip = bind_properties(
        target=stream,
        props=("is_muted", "volume"),
        transform=get_tooltip,
    )

    component, _ = revealer(
        head=button,
        child=slider,
        tooltip=tooltip,
    )

    return component

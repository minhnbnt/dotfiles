#!/usr/bin/env python3

import json
import os
import socket
import subprocess
import sys

ICONS = ["", "", "", "", "", "", ""]
OTHER_ICON = ""

ACTIVE_CLASSNAME = "active"
VISIBLE_CLASSNAME = "visible"
EMPTY_CLASSNAME = "inactive"


def print_widget(visible_workspaces: set[int], active_workspace: int):
    visible_workspaces = set(visible_workspaces)

    print(f'(eventbox :onscroll "python3 {__file__!r} {{}}"', end=" ")
    print('(box :class "works" :orientation "v" :space-evenly false', end="")

    def print_button(id: int, button_class: str, icon: str):
        print(f' (button :tooltip "Workspace {id}"', end=" ")

        print(f':onclick "hyprctl dispatch workspace {id}"', end=" ")
        print(f':onrightclick "hyprctl dispatch workspace {id}"', end=" ")

        print(f':class "{button_class}" "{icon}"', end=")")

    for id, icon in enumerate(ICONS, start=1):
        button_class = EMPTY_CLASSNAME

        if id in visible_workspaces:
            button_class = VISIBLE_CLASSNAME
            visible_workspaces.remove(id)

        if id == active_workspace:
            button_class = ACTIVE_CLASSNAME

        print_button(id, button_class, icon)

    for id in sorted(visible_workspaces):
        button_class = EMPTY_CLASSNAME

        if id == active_workspace:
            button_class = ACTIVE_CLASSNAME

        print_button(id, button_class, OTHER_ICON)

    print("))", flush=True)


def init_widget():
    command = ["hyprctl", "workspaces", "-j"]
    output = subprocess.check_output(command)

    visible_workspaces = set()
    for work in json.loads(output):
        visible_workspaces.add(work["id"])

    command[1] = "activeworkspace"
    output = subprocess.check_output(command)

    active_workspace = json.loads(output)["id"]

    return visible_workspaces, active_workspace


def args_handle(argv: list[str]):
    if len(argv) == 1:
        return

    if len(argv) > 2:
        raise ValueError("Too many arguments.")

    command = ["hyprctl", "dispatch", "workspace"]

    match argv[1]:
        case "up":
            command.append("e-1")
        case "down":
            command.append("e+1")

        case _:
            raise RuntimeError("Invalid argument.")

    subprocess.run(command)
    sys.exit(0)


def update_workspace(buf: str):
    changed = False

    def get_number(line: str) -> int:
        return int(line.split(">>")[1])

    global active_workspace, visible_workspaces

    for line in buf.splitlines():
        if line.startswith("workspace>>"):
            active_workspace = get_number(line)
            changed = True

        elif line.startswith("createworkspace>>"):
            visible_workspaces.add(get_number(line))
            changed = True

        elif line.startswith("destroyworkspace>>"):
            visible_workspaces.discard(get_number(line))
            changed = True

    return changed


with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
    args_handle(sys.argv)

    try:
        xdgRuntimeDir = os.environ["XDG_RUNTIME_DIR"]
        signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]

        sock.connect(f"{xdgRuntimeDir}/hypr/{signature}/.socket2.sock")

    except (KeyError, FileNotFoundError) as e:
        raise ValueError(f"{e}. Is your hyprland running?.")

    visible_workspaces, active_workspace = init_widget()
    print_widget(visible_workspaces, active_workspace)

    while True:
        buf = sock.recv(1024).decode()

        if changed := update_workspace(buf):
            print_widget(visible_workspaces, active_workspace)

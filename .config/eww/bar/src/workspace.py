#!/usr/bin/env python3

import json, os, socket, subprocess, sys

ICONS = ["", "", "", "", "", "", ""]
OTHER_ICON = ""


def print_widget(visible_workspaces, active_workspace):
    visible_workspaces = set(visible_workspaces)

    print(f'(eventbox :onscroll "python3 {__file__!r}', '{}"', end=" ")
    print('(box :class "works" :orientation "v" :space-evenly false', end="")

    def print_button(id, button_class, icon):
        print(f' (button :tooltip "Workspace {id}"', end=" ")

        print(f':onclick "hyprctl dispatch workspace {id}"', end=" ")
        print(f':onrightclick "hyprctl dispatch workspace {id}"', end=" ")

        print(f':class "{button_class}" "{icon}"', end=")")

    for id, icon in enumerate(ICONS):
        id += 1

        button_class = "inactive"

        if id == active_workspace:
            button_class = "active"
        elif id in visible_workspaces:
            button_class = "visible"

        visible_workspaces.discard(id)

        print_button(id, button_class, icon)

    for id in sorted(visible_workspaces):
        button_class = "inactive"

        if id == active_workspace:
            button_class = "active"

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


def args_handle(argv):
    if len(argv) == 1:
        return

    if len(argv) > 2:
        raise ValueError("Too many arguments.")

    command = ["hyprctl", "dispatch", "workspace"]

    if argv[1] == "up":
        command.append("e-1")
    elif argv[1] == "down":
        command.append("e+1")

    else:
        raise RuntimeError("Invalid argument.")

    subprocess.run(command)
    sys.exit(0)


def update_workspace(buf):
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

    signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
    sock.connect(f"/tmp/hypr/{signature}/.socket2.sock")

    visible_workspaces, active_workspace = init_widget()
    print_widget(visible_workspaces, active_workspace)

    while True:
        buf = sock.recv(1024).decode()

        if buf and update_workspace(buf):
            print_widget(visible_workspaces, active_workspace)

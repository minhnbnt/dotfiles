#!/usr/bin/env python3

import json, os, socket, subprocess, sys

ICONS = ["", "", "", "", "", "", ""]
OTHER_ICON = ""

argv = sys.argv

if len(argv) > 2:
    print("Too many arguments")
    sys.exit(1)

if len(argv) == 2:
    if argv[1] == "up":
        os.system("hyprctl dispatch workspace e-1")
    elif argv[1] == "down":
        os.system("hyprctl dispatch workspace e+1")

    else:
        print("Invalid argument")
        sys.exit(1)

    sys.exit(0)


def init_widget():
    output = subprocess.check_output(["hyprctl", "workspaces", "-j"])

    visible_workspaces = set(work["id"] for work in json.loads(output))

    output = subprocess.check_output(["hyprctl", "activeworkspace", "-j"])
    active_workspace = json.loads(output)["id"]

    return visible_workspaces, active_workspace


def update_workspace(buf):
    global active_workspace

    changed = False

    def get_number(line: str):
        return int(line.split(">>")[1])

    for line in buf.splitlines():
        if line.startswith("workspace>>"):
            active_workspace = get_number(line)
            changed = True

        elif line.startswith("createworkspace>>"):
            visible_workspaces.add(get_number(line))
            changed = True

        elif line.startswith("destroyworkspace>>"):
            workspace_id = get_number(line)

            if workspace_id in visible_workspaces:
                visible_workspaces.remove(workspace_id)
                changed = True

    return changed


def print_widget(visible_workspaces, active_workspace):
    visible_set = set(sorted(visible_workspaces))

    print(f"(eventbox :onscroll 'python3 {__file__} {{}}'", end=" ")
    print('(box :class "works" :orientation "v" :space-evenly false', end="")

    # print all workspaces in icons list
    for id, icon in enumerate(ICONS):
        id = id + 1

        print(f' (button :tooltip "Workspace {id}"', end=" ")

        print(f':onclick "hyprctl dispatch workspace {id}"', end=" ")
        print(f':onrightclick "hyprctl dispatch workspace {id}"', end=" ")

        button_class = "inactive"
        if id == active_workspace:
            button_class = "active"
        elif id in visible_set:
            button_class = "visible"

        if id in visible_set:
            visible_set.remove(id)

        print(f':class "{button_class}" "{icon}"', end=")")

    # if there are any visible workspaces that are not in the icons list
    for id in visible_set:
        print(f' (button :tooltip "Workspace {id}"', end=" ")

        if id == active_workspace:
            print(f':class "active" "{OTHER_ICON}', end='")')
            continue

        # visible workspace not in icons list
        print(':onclick "hyprctl dispatch workspace', id, end='" ')
        print(':onrightclick "hyprctl dispatch workspace', id, end='" ')
        print(f':class "visible" " {OTHER_ICON}', end='")')

    print("))")

    # flush stdout so that the widget is updated immediately
    sys.stdout.flush()


with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
    signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
    sever_address = f"/tmp/hypr/{signature}/.socket2.sock"

    sock.connect(sever_address)

    visible_workspaces, active_workspace = init_widget()
    print_widget(visible_workspaces, active_workspace)

    while True:
        buf = sock.recv(1024).decode()

        if buf and update_workspace(buf):
            print_widget(visible_workspaces, active_workspace)

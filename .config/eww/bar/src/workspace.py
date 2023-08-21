#!/usr/bin/env python3

import json, os, socket, subprocess, sys

icons = ["", "", "", "", "", "", ""]
other_icon = ""

argv_len = len(sys.argv)

if argv_len > 2:
    print("Too many arguments")
    sys.exit(1)

elif argv_len == 2:
    if sys.argv[1] == "up":
        os.system("hyprctl dispatch workspace e-1")
    elif sys.argv[1] == "down":
        os.system("hyprctl dispatch workspace e+1")

    else:
        print("Invalid argument")
        sys.exit(1)

    sys.exit(0)


def init_widget():
    visible_workspaces = set()

    output = subprocess.check_output(["hyprctl", "workspaces", "-j"])

    for workspace in json.loads(output):
        visible_workspaces.add(workspace["id"])

    output = subprocess.check_output(["hyprctl", "activeworkspace", "-j"])
    active_workspace = json.loads(output)["id"]

    return visible_workspaces, active_workspace


visible_workspaces, active_workspace = init_widget()


def update_workspace(buf):
    global active_workspace

    changed = False

    def get_number(line):
        return int(line.split(">>")[1])

    for line in buf.splitlines():
        if line.startswith("workspace>>"):
            active_workspace = get_number(line)
            changed = True

        if line.startswith("createworkspace>>"):
            visible_workspaces.add(get_number(line))
            changed = True

        if line.startswith("destroyworkspace>>"):
            workspace_id = get_number(line)

            if workspace_id in visible_workspaces:
                visible_workspaces.remove(workspace_id)
                changed = True

    return changed


def print_widget():
    visible_set = set(sorted(visible_workspaces))

    print('(eventbox :onscroll "python3', "'" + __file__ + "'", '{}"', end=" ")
    print('(box :class "works" :orientation "v" :space-evenly false', end="")

    # print all workspaces in icons list
    for id, icon in enumerate(icons):
        id = id + 1

        print(' (button :tooltip "Workspace {}"'.format(id), end=" ")

        print(':onclick "hyprctl dispatch workspace', id, end='" ')
        print(':onrightclick "hyprctl dispatch workspace', id, end='" ')

        button_class = "inactive"
        if id == active_workspace:
            button_class = "active"
        elif id in visible_set:
            button_class = "visible"

        if id in visible_set:
            visible_set.remove(id)

        print(':class "{}" "{}"'.format(button_class, icon), end=")")

    # if there are any visible workspaces that are not in the icons list
    for id in visible_set:
        print(' (button :tooltip "Workspace {}"'.format(id), end=" ")

        if id == active_workspace:
            print(':class "active" "' + other_icon, end='")')
            continue

        # visible workspace not in icons list
        print(':onclick "hyprctl dispatch workspace', id, end='" ')
        print(':onrightclick "hyprctl dispatch workspace', id, end='" ')
        print(':class "visible" "' + other_icon, end='")')

    print("))")

    # flush stdout so that the widget is updated immediately
    sys.stdout.flush()


signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
sever_address = "/tmp/hypr/" + signature + "/.socket2.sock"

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect(sever_address)

print_widget()

while True:
    buf = sock.recv(1024).decode()

    if not buf:
        continue

    if update_workspace(buf):
        print_widget()

#!/usr/bin/env python3

import os, socket, subprocess, sys

icons = ["", "", "", "", "", "", ""]
other_icon = ""

signature = os.environ["HYPRLAND_INSTANCE_SIGNATURE"]
sever_address = "/tmp/hypr/" + signature + "/.socket2.sock"

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

    output = subprocess.check_output(["hyprctl", "workspaces"])
    for line in output.decode().splitlines():
        if line.startswith("workspace ID"):
            workspace_number = int(line.split()[2])
            visible_workspaces.add(workspace_number)

    output = subprocess.check_output(["hyprctl", "activeworkspace"])
    active_workspace = int(output.decode().split()[2])

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
    print('(box :class "works" :orientation "v" :space-evenly false', end=" ")

    # print all workspaces in icons list
    for i, icon in enumerate(icons):
        index = i + 1

        print('(button :onclick "hyprctl dispatch workspace', index, end='" ')
        print(':onrightclick "hyprctl dispatch workspace', index, end='" ')
        print(':tooltip "Workspace {}"'.format(index), end=" ")

        button_class = "inactive"
        if index == active_workspace:
            button_class = "active"
            visible_set.remove(index)
        elif index in visible_set:
            button_class = "visible"
            visible_set.remove(index)

        print(':class "{}" "{}")'.format(button_class, icon), end=" ")

    # if there are any visible workspaces that are not in the icons list
    for i in visible_set:
        print('(button :tooltip "Workspace {}"'.format(i), end=" ")

        if i == active_workspace:
            print(':class "active" "' + other_icon, end='") ')
            continue

        # visible workspace not in icons list
        print(':onclick "hyprctl dispatch workspace', i, end='" ')
        print(':onrightclick "hyprctl dispatch workspace', i, end='" ')
        print(':class "visible" "' + other_icon + '")', end=" ")

    print("))")

    # flush stdout so that the widget is updated immediately
    sys.stdout.flush()


sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

try:
    sock.connect(sever_address)
except Exception as e:
    print("Failed to connect to server: ", e)
    sys.exit(1)

print_widget()

while True:
    buf = sock.recv(1024).decode()

    if not buf:
        break

    changed = update_workspace(buf)

    if changed:
        print_widget()

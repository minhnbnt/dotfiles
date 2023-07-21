#!/usr/bin/env python3

import os, socket, subprocess, sys

icons = ["", "", "", "", "", "", ""]
other_icon = ""

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
    visible_workspace = set()

    output = subprocess.check_output(["hyprctl", "workspaces"])
    for line in output.decode().splitlines():
        if line.startswith("workspace ID"):
            workspace_number = int(line.split()[2])
            visible_workspace.add(workspace_number)

    output = subprocess.check_output(["hyprctl", "activeworkspace"])
    active_workspace = int(output.decode().split()[2])

    return visible_workspace, active_workspace


visible_workspace, active_workspace = init_widget()


def update_workspace(buf: str):
    global active_workspace

    def get_number(line):
        return int(line.split(">>")[1])

    for line in buf.splitlines():
        if line.startswith("workspace>>"):
            active_workspace = get_number(line)
            return True
        if line.startswith("createworkspace>>"):
            visible_workspace.add(get_number(line))
            return True
        if line.startswith("destroyworkspace>>"):
            visible_workspace.remove(get_number(line))
            return True

    return False


def print_widget():
    global icons

    print('(eventbox :onscroll "python3', "'" + __file__ + "'", '{}"', end=" ")
    print('(box :class "works" :orientation "v" :space-evenly false', end=" ")

    def get_icon(index):
        global icons, other_icon

        if index < len(icons):
            return icons[index - 1]

        return other_icon

    for i, icon in enumerate(icons):
        index = i + 1

        print('(button :onclick "hyprctl dispatch workspace', index, end='" ')
        print(':onrightclick "hyprctl dispatch workspace', index, end='" ')

        if index == active_workspace:
            print(':class "active" "' + icon + '")', end=" ")
        elif index in visible_workspace:
            print(':class "visible" "' + icon + '")', end=" ")
        else:
            print(':class "inactive" "' + icon + '")', end=" ")

    if active_workspace > len(icons):
        print('(button :class "active" "' + other_icon + '")', end=" ")

    print("))")

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

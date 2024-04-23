const revealChild = Variable(false);

function runDialog({ title, prompt, command }) {
    Utils.exec(
        `/home/minhnbnt/.config/eww/bar/bin/eww_power_dialog \
        -t "${title}" -m "${prompt}" -c "${command}"`
    );
}

function suspend() {
    return Widget.Button({
        label: '',
        className: 'button-sus',
        onClicked: () =>
            runDialog({
                title: 'Are you sure?',
                prompt: 'Do you really want to suspend?',
                command: 'systemctl suspend'
            })
    });
}

function exit() {
    return Widget.Button({
        label: '',
        className: 'button-exit',
        onClicked: () =>
            runDialog({
                title: 'Are you sure?',
                prompt: 'Do you really want to exit Hyprland?',
                command: 'hyprctl dispatch exit --'
            })
    });
}

function restart() {
    return Widget.Button({
        label: '',
        className: 'button-res',
        onClicked: () =>
            runDialog({
                title: 'Are you sure?',
                prompt: 'Do you really want to restart?',
                command: 'reboot'
            })
    });
}

function revealer() {
    return Widget.Revealer({
        transition: 'slide_up',
        transitionDuration: 550,
        child: Widget.Box({
            vertical: true,
            children: [suspend(), exit(), restart()]
        })
    }).hook(revealChild, (self) => self.set_reveal_child(revealChild.value));
}

function shutdown() {
    return Widget.Button({
        label: '',
        onClicked: () =>
            runDialog({
                title: 'Are you sure?',
                prompt: 'Do you really want to shutdown?',
                command: 'shutdown -P now'
            })
    });
}

export default function PowerMenu() {
    return Widget.EventBox({
        onHover: () => (revealChild.value = true),
        setup: (self) =>
            self.on('leave-notify-event', () => {
                revealChild.value = false;
            }),

        child: Widget.Box({
            vertical: true,
            spacing: 0,
            children: [revealer(), shutdown()]
        })
    });
}

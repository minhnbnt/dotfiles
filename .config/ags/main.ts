import PowerMenu from 'components/powermenu';
import Workspaces from 'components/workspaces';
import Clock from 'components/clock';
import Battery from 'components/battery';
import Network from 'components/network';
import Audio from 'components/audio';

function Bar(monitor: number) {
    return Widget.Window({
        name: `bar-${monitor}`,
        class_name: 'bar',
        monitor,
        anchor: ['top', 'left', 'bottom'],
        exclusivity: 'exclusive',
        child: Widget.CenterBox({
            vertical: true,
            startWidget: Workspaces(),
            end_widget: Widget.Box({
                vpack: 'end',
                vertical: true,
                children: [Network(), Battery(), Audio(), Clock(), PowerMenu()]
            })
        })
    });
}

App.config({
    windows: [Bar(0)]
});

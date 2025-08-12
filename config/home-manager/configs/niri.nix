{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ignis
    niri
    xwayland-satellite
    swww
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    uwsm
  ];

  systemd.user.targets."niri-session".Unit = {
    Description = "Niri compositor session";
    BindsTo = "graphical-session.target";
    Before = [ "xdg-desktop-autostart.target" ];
    After = [ "graphical-session-pre.target" ];
    Wants = [
      "graphical-session-pre.target"
      "xdg-desktop-autostart.target"
    ];
  };

  xdg.configFile."niri/integrations.sh".text = builtins.concatStringsSep ";\n" [
    "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome"
    "systemctl --user stop niri-session.target"
    "systemctl --user start niri-session.target"
  ];
}

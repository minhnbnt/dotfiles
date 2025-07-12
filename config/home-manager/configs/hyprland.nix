{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grim
    wofi
    wl-clipboard-rs
    swww

    ignis
  ];

  wayland.windowManager.hyprland = {

    enable = true;
    systemd.enableXdgAutostart = true;

    settings.source = [
      "~/.config/hypr/hyprland/main.conf"
    ];
  };

  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun";
      allow_images = true;
      normal_window = true;
    };
  };
}

{ pkgs, ignisPkgs, ... }:

{
  home.packages = [
    pkgs.grim
    pkgs.wofi
    pkgs.wl-clipboard-rs
    pkgs.swww

    ignisPkgs.ignis
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

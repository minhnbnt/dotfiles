{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grim
    slurp
    wofi
    wl-clipboard-rs
    swww

    ignis
    uwsm
  ];

  programs.wofi = {
    enable = true;
    settings = {
      mode = "drun";
      allow_images = true;
      normal_window = true;
    };
  };

  services.hyprpolkitagent.enable = true;

  wayland.windowManager.hyprland = {

    enable = true;
    systemd.enableXdgAutostart = true;

    settings.source = [
      "~/.config/hypr/hyprland/main.conf"
    ];
  };

  services.hypridle = {

    enable = true;
    settings = {

      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10";
        }
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}

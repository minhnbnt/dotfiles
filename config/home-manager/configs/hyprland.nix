{
  config,
  dotDirectory,
  pkgs,
  ...
}:

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

  home.file =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      ".config/ignis".source = mkSymlink "${dotDirectory}/config/ignis";
      ".config/hypr/hyprland".source = mkSymlink "${dotDirectory}/config/hypr/hyprland";
      ".config/hypr/scripts".source = mkSymlink "${dotDirectory}/config/hypr/scripts";
      ".config/wofi/style.css".source = mkSymlink "${dotDirectory}/config/wofi.css";
    };

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

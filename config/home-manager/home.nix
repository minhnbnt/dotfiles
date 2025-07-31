{
  config,
  lib,
  pkgs,
  dotDirectory,
  ...
}:

{
  imports = [ ./configs ];

  home.stateVersion = "25.05";

  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "osu-lazer-bin"
    ];

  programs.obs-studio.enable = true;
  programs.zed-editor.enable = true;

  home.packages = with pkgs; [

    brave
    librewolf
    qutebrowser

    gimp3
    vlc

    jetbrains.idea-community-bin
    jetbrains.pycharm-community-bin

    pnpm
    nodePackages_latest.nodejs

    clang
    gitleaks
    hurl
    kubectl
    lazydocker
    minikube
    opentofu

    nh

    anki-bin
    osu-lazer-bin

    quickshell
  ];

  home.file =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      ".profile".source = mkSymlink "${dotDirectory}/profile";
      ".config/home-manager".source = mkSymlink "${dotDirectory}/config/home-manager";
      ".config/ghostty/config".source = mkSymlink "${dotDirectory}/config/ghostty";
      ".config/nvim".source = mkSymlink "${dotDirectory}/config/nvim";
      ".config/ignis".source = mkSymlink "${dotDirectory}/config/ignis";
      ".config/fastfetch/config.jsonc".source = mkSymlink "${dotDirectory}/config/fastfetch.jsonc";
      ".config/hypr/hyprland".source = mkSymlink "${dotDirectory}/config/hypr/hyprland";
      ".config/hypr/scripts".source = mkSymlink "${dotDirectory}/config/hypr/scripts";
      ".config/wofi/style.css".source = mkSymlink "${dotDirectory}/config/wofi.css";
    };

  home.sessionVariables = {
    NH_HOME_FLAKE = "${config.xdg.configHome}/home-manager";
  };

  programs.home-manager.enable = true;
}

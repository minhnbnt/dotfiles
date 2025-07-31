{
  config,
  dotDirectory,
  lib,
  pkgs,
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
  programs.home-manager.enable = true;

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

  home.file = {
    ".config/home-manager".source =
      config.lib.file.mkOutOfStoreSymlink "${dotDirectory}/config/home-manager";
  };

  home.sessionVariables = {
    NH_HOME_FLAKE = "${config.xdg.configHome}/home-manager";
  };
}

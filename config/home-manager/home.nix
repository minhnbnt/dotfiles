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
      "osu-lazer-bin" # spellchecker:disable-line
    ];

  programs.obs-studio.enable = true;
  programs.zed-editor.enable = true;
  programs.home-manager.enable = true;

  programs.java.enable = true;

  home.packages = with pkgs; [

    brave
    librewolf
    qutebrowser
    xfce.thunar

    gimp3
    vlc

    jetbrains.idea-community-bin
    jetbrains.pycharm-community-bin

    clang
    pnpm
    (buildFHSEnv {
      name = "pixi";
      runScript = "pixi";
      targetPkgs = pkgs: [ pkgs.pixi ];
    })
    nodePackages_latest.nodejs

    gitleaks
    hurl
    jq
    kubectl
    lazydocker
    minikube
    opentofu

    nmap
    rustscan

    nh

    anki-bin
    osu-lazer-bin # spellchecker:disable-line

    #quickshell
  ];

  home.file.".config/home-manager".source =
    config.lib.file.mkOutOfStoreSymlink "${dotDirectory}/config/home-manager";

  home.sessionVariables = {
    NH_HOME_FLAKE = "${config.xdg.configHome}/home-manager";
  };
}

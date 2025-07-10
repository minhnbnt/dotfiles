{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "minhnbnt";
  home.homeDirectory = "/home/minhnbnt";

  imports = [ ./configs ];

  home.stateVersion = "25.05";

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

  home.packages = with pkgs; [

    btop
    brave
    librewolf
    vlc

    jetbrains.idea-community
    jetbrains.pycharm-community

    pnpm
    nodePackages_latest.nodejs

    gcc
    gitleaks
    jujutsu

    osu-lazer-bin
  ];

  home.file =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      dotDirectory = "${config.home.homeDirectory}/dotfiles";
    in
    {
      ".zshrc".source = mkSymlink "${dotDirectory}/zshrc";
      ".profile".source = mkSymlink "${dotDirectory}/profile";
      ".config/home-manager".source = mkSymlink "${dotDirectory}/config/home-manager";
      ".config/ghostty/config".source = mkSymlink "${dotDirectory}/config/ghostty";
      ".config/zsh".source = mkSymlink "${dotDirectory}/config/zsh";
      ".config/nvim".source = mkSymlink "${dotDirectory}/config/nvim";
      ".config/ignis".source = mkSymlink "${dotDirectory}/config/ignis";
      ".config/fastfetch/config.jsonc".source = mkSymlink "${dotDirectory}/config/fastfetch.jsonc";
      ".config/hypr/hyprland".source = mkSymlink "${dotDirectory}/config/hypr/hyprland";
      ".config/wofi/style.css".source = mkSymlink "${dotDirectory}/config/wofi.css";
    };

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}

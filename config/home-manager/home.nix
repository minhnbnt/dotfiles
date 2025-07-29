{
  config,
  pkgs,
  dotDirectory,
  ...
}:

{
  imports = [ ./configs ];

  home.stateVersion = "25.05";

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };

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
    lazydocker
    minikube

    anki

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

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}

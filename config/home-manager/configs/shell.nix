{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    daemon.enable = true;
    settings = {
      enter_accept = true;

      inline_height = 20;
      show_help = false;
      show_tabs = false;

      style = "full";
    };
  };

  programs.eza.enable = true;
  programs.starship.enable = true;

  programs.zoxide.enable = true;

  home.packages = with pkgs; [

    ghostty

    fastfetch
    btop
    eza
  ];
}

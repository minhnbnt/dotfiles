{ pkgs, ... }:

{
  home.packages = [

    pkgs.ghostty

    pkgs.fastfetch
    pkgs.eza
    pkgs.atuin
    pkgs.zoxide
    pkgs.starship
    pkgs.zsh-autocomplete
    pkgs.zsh
  ];
}

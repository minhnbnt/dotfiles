{ pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "FreeSerif" ];
      sansSerif = [ "Adwaita Sans" ];
      monospace = [ "FiraCode Nerd Font Mono" ];
    };
  };

  home.packages = [
    pkgs.noto-fonts-cjk-sans
    pkgs.nerd-fonts.fira-code
    pkgs.adwaita-fonts
    pkgs.freefont_ttf
  ];
}

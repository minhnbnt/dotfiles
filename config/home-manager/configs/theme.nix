{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Yaru-blue-dark";
      package = pkgs.yaru-theme;
    };
  };

  home.pointerCursor = {
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 24;
  };

  home.packages = [
    pkgs.adwaita-icon-theme
    pkgs.dconf
  ];
}

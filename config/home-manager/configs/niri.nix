{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ignis
    niri
    xwayland-satellite
    swww
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    uwsm
  ];
}

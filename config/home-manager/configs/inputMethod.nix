{ pkgs, ... }:

{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      addons = [
        pkgs.fcitx5-bamboo
        pkgs.fcitx5-mozc-ut

        pkgs.fcitx5-gtk
        pkgs.libsForQt5.fcitx5-qt
      ];
    };
  };
}

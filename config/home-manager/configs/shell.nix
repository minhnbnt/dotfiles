{
  config,
  dotDirectory,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh = {

    enable = true;
    dotDir = ".config/zsh";

    initContent = lib.mkOrder 1500 "source ${dotDirectory}/config/zsh/extra.zsh";

    history = {
      saveNoDups = true;
      path = "${config.xdg.dataHome}/zsh/zsh_history";
    };

    antidote = {
      enable = true;
      plugins = [

        "zsh-users/zsh-completions kind:fpath path:src"
        "zsh-users/zsh-autosuggestions"
        "marlonrichert/zsh-autocomplete"
        "zdharma-continuum/fast-syntax-highlighting kind:defer"

        "g-plane/pnpm-shell-completion"

        "ohmyzsh/ohmyzsh path:lib/directories.zsh"
        "ohmyzsh/ohmyzsh path:lib/functions.zsh"
        "ohmyzsh/ohmyzsh path:lib/termsupport.zsh"
      ];
    };
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

  programs.eza = {
    enable = true;
    icons = "always";
    extraOptions = [
      "--almost-all"
      "--group-directories-first"
      "--header"
    ];
  };

  programs.starship.enable = true;

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd=cd"
    ];
  };

  home.packages = with pkgs; [
    fastfetch
    ghostty
  ];
}

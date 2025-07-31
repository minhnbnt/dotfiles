{
  config,
  dotDirectory,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
  };

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotDirectory}/config/nvim";
  };

  home.packages = with pkgs; [
    ansible-language-server
    basedpyright
    clang-tools
    emmet-language-server
    gopls
    kdePackages.qtdeclarative # qmlls
    lua-language-server
    nixd
    typos-lsp
    ruff
    rust-analyzer
    svelte-language-server
    tailwindcss-language-server
    terraform-ls
    vtsls
    vscode-langservers-extracted

    go # gofmt
    golangci-lint
    nixfmt-rfc-style
    nodePackages.prettier
    shfmt
    stylua
    kdlfmt

    ripgrep
  ];
}

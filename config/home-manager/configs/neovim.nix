{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
  };

  home.packages = with pkgs; [
    ansible-language-server
    basedpyright
    clang-tools
    emmet-language-server
    gopls
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
  ];
}

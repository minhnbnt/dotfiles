# dotfiles

This is my dotfiles for my Linux. Enjoy to use :)))

## Neovim

You need to install [packer.nvim](https://github.com/wbthomason/packer.nvim) for plugins.

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Open Neovim and enter folowing command.

```vim
:PackerCompile
:PackerSync
```

## Zsh

If you are using Arch Linux, you can run this command to install plugins.

```bash
yay -S zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete-git zsh-autopair-git
```

Or you need to edit plugins path, install manually or disable it.

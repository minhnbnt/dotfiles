# dotfiles

This is my dotfiles for my Linux. Enjoy to use :)))

## Install

We need git and stow for installation.

```sh
pacman -S git stow
```

Clone my repository.

```sh
git clone git@github.com:minhnbnt/dotfiles.git ~/dotfiles
```

Then use GNU stow to create symlinks.

```sh
cd ~/dotfiles
stow --adopt .
```

The `stow --adopt` command will create symlinks without overwriting existing files.
However, it's still recommended to have a backup in case of conflicts.

## Zsh

You can run this command to install plugins.

```sh
yay -S zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete zsh-autopair-git
```

Or you need to edit plugins path, then install manually.

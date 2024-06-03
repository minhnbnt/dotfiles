#
# ~/.zshrc
#
# If not running interactively, don't do anything

if [[ $- != *i* ]]; then
	return
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d $ZINIT_HOME ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
fi

if [ ! -d $ZINIT_HOME/.git ]; then
	git clone git@github.com:zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz compinit
compinit

zinit cdreplay -q

# I use Arch, BTW
fastfetch

# Load configuration files in ~/.config/zsh/
for conf in "$HOME/.config/zsh/"*.zsh; do
	source "${conf}"
done

unset conf


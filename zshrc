#
# ~/.zshrc
#
# If not running interactively, don't do anything

if [[ $- != *i* ]]; then
	return
fi

declare -A ZINIT
ZINIT[ZCOMPDUMP_PATH]="${HOME}/.local/share/zsh/zcompdump"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d $ZINIT_HOME ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
fi

if [ ! -d $ZINIT_HOME/.git ]; then
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zicompinit
zinit cdreplay -q

# Load configuration files in ~/.config/zsh/
for conf in "$HOME/.config/zsh/"*.zsh; do
	source "${conf}"
done

unset conf

# I use Arch, BTW
fastfetch

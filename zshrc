#
# ~/.zshrc
#
# If not running interactively, don't do anything

if [[ $- != *i* ]]; then
	return
fi

typeset -U fpath
declare -A ZINIT

for profile in ${(z)NIX_PROFILES}; do
	fpath+=($profile/share/zsh/site-functions \
	        $profile/share/zsh/$ZSH_VERSION/functions \
	        $profile/share/zsh/vendor-completions)
done

zsh_nix_help_dir="${HOME}/.nix-profile/share/zsh/$ZSH_VERSION"
if [ -d "$zsh_nix_help_dir" ]; then
	HELPDIR="${zsh_nix_help_dir}/help"
fi

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

# Load configuration files in ~/.config/zsh/
for conf in "$HOME/.config/zsh/"*.zsh; do
	source "${conf}"
done

zinit cdreplay -q

unset conf zsh_nix_help_dir

# I use Arch, BTW
fastfetch

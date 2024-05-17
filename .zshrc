#
# ~/.zshrc
#
# If not running interactively, don't do anything

if [[ $- != *i* ]]; then
	return
fi

fastfetch

for conf in "$HOME/.config/zsh/"*.zsh; do
	source "${conf}"
done

unset conf

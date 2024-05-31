ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d $ZINIT_HOME ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
fi

if [ ! -d $ZINIT_HOME/.git ]; then
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light marlonrichert/zsh-autocomplete
zinit light hlissner/zsh-autopair
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

eval "$(atuin init zsh)"
eval "$(thefuck --alias)"
eval "$(zoxide init zsh --cmd cd)"

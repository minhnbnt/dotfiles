autoload -U compinit; compinit

bindkey -e
bindkey "^[[3~" delete-char

PLUGINS_DIR=/usr/share/zsh/plugins

source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $PLUGINS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $PLUGINS_DIR/zsh-autopair/autopair.zsh

ZSH_HIGHLIGHT_STYLES[precommand]=fg=11,underline
ZSH_HIGHLIGHT_STYLES[function]=fg=14
ZSH_HIGHLIGHT_STYLES[alias]=fg=13
ZSH_HIGHLIGHT_STYLES[command]=fg=14
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=3
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=3

eval "$(thefuck --alias)"
eval "$(zoxide init zsh --cmd cd)"

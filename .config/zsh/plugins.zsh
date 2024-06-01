ZOXIDE_CMD_OVERRIDE=cd

zinit light hlissner/zsh-autopair
zinit light marlonrichert/zsh-autocomplete
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

zinit snippet OMZP::archlinux
zinit snippet OMZP::git
zinit snippet OMZP::sudo

eval "$(atuin init zsh)"
eval "$(thefuck --alias)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

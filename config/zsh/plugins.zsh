zinit light hlissner/zsh-autopair
zinit light marlonrichert/zsh-autocomplete
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

zinit snippet OMZL::directories.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::termsupport.zsh

zinit snippet OMZP::git
zinit snippet OMZP::sudo

eval "$(atuin init zsh)"
eval "$(zoxide init zsh --cmd cd)"

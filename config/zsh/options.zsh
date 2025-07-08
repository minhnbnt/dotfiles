HISTFILE=$HOME/.local/share/zsh/zsh_history
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTDUP=erase

setopt APPENDHISTORY
setopt SHAREHISTORY

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt INTERACTIVECOMMENTS

bindkey -e
bindkey '^[[3~' delete-char

zstyle ':autocomplete:*' key-binding off

# zsh-syntax-highlighting
typeset -A ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[precommand]=fg=11,underline
ZSH_HIGHLIGHT_STYLES[function]=fg=14
ZSH_HIGHLIGHT_STYLES[alias]=fg=13
ZSH_HIGHLIGHT_STYLES[command]=fg=14
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=3
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=3

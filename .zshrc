#
# ~/.zshrc
#
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

#clear

autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# Title for terminal

function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m:%~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m:%~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# Git diff in prompt

precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%F{6}[%F{#f05033}%f %b%F{6}]%f'
zstyle ':vcs_info:*' formats " %F{cyan}%c%u(%b)%f"
zstyle ':vcs_info:*' actionformats " %F{cyan}%c%u(%b)%f %a"
zstyle ':vcs_info:*' stagedstr "%F{green}"
zstyle ':vcs_info:*' unstagedstr "%F{red}"
zstyle ':vcs_info:*' check-for-changes true

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Command number

[[ $cmdcount -ge 1 ]] || cmdcount=1
preexec() { ((cmdcount++)) }

ZSH_HIGHLIGHT_STYLES[precommand]=fg=11,underline
ZSH_HIGHLIGHT_STYLES[function]=fg=14
ZSH_HIGHLIGHT_STYLES[alias]=fg=13
ZSH_HIGHLIGHT_STYLES[command]=fg=14
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=3
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=3

# Use local file only for zsh-autocomplete

__git_files () { _wanted files expl 'local files' _files }

# Better history

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000000
SAVEHIST=1000000000

# Some options

setopt PROMPT_SUBST
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# PS1 prompt, look bad right?

if [[ $(whoami) == "root" ]]; then
	PS1='%F{6}┌─%f%F{6}[%f%B%F{15}$cmdcount%f%b%F{6}]%(?,,%F{6}[%f%B%F{9}%?%f%b%F{6}])─%f%F{6}[%f%B%F{11}%n%f%b%B%F{8}@%f%b%B%F{12}%m%f%b%F{6}]─[%f%F{13}%~%f%F{6}]%f'$'\n''%F{6}└╼%f%b %f%B%F{14}$%f%b '
else
    #RPROMPT='${vcs_info_msg_0_}'
	PS1='%F{6}┌─%f%F{6}[%f%B%F{15}$cmdcount%f%b%F{6}]%(?,,%F{6}[%f%B%F{9}%?%f%b%F{6}])─%f%F{6}[%f%B%F{10}%n%f%b%B%F{8}@%f%b%B%F{12}%m%f%b%F{6}]─[%f%F{13}%~%f%F{6}]${vcs_info_msg_0_}%f'$'\n''%F{6}└╼%f%b %f%B%F{14}$%f%b '
fi

# Some of my custom command

neofetch(){/usr/bin/neofetch --stdout --config ~/.config/neofetch/configzsh.conf | sed '/^$/d'}
ls(){/usr/bin/ls -Ahv --color --group-directories-first "$@"}
matrix(){/usr/bin/neo-matrix -D "$@"}

tlauncher(){(java -jar /home/minhnbnt/.tlauncher/TLauncher-2.86.jar "$@" > /dev/null 2>&1 &)}
deadcells(){(sh /mnt/d/Dead\ Cells\ Linux/start.sh "$@" > /dev/null 2>&1 &)}
undertale(){(sh /mnt/d/Undertale/start.sh "$@" > /dev/null 2>&1 &)}
gungeon(){(sh /mnt/d/Enter\ the\ Gungeon/start.sh "$@" > /dev/null 2>&1 &)}

chrome(){(/usr/bin/google-chrome-stable "$@" > /dev/null 2>&1 &)}
chromium(){(/usr/bin/chromium %U "$@" > /dev/null 2>&1 &)}

#vscode(){(/usr/bin/code --no-sandbox --new-window "$@" > /dev/null 2>&1 &)}
eclipse(){(/usr/bin/eclipse "$@" > /dev/null 2>&1 &)}
neovim(){(/usr/bin/nvim-qt "$@" > /dev/null 2>&1 &)}
vi(){/usr/bin/nvim "$@"}
emacs(){
	if [[ "$@" == *"-nw"* ]] || [[ "$@" == *"--no-window-system"* ]] then
		/usr/bin/emacs "$@"
	else
		(/usr/bin/emacs "$@" > /dev/null 2>&1 &)
	fi
}
i3config(){nvim ~/.config/i3/config}

discord(){(/usr/bin/discord "$@" > /dev/null 2>&1 &)}
teams(){(/usr/bin/teams "$@" > /dev/null 2>&1 &)}
zoom(){(/usr/bin/zoom "$@" > /dev/null 2>&1 &)}

nautilus(){(/usr/bin/nautilus "$@" > /dev/null 2>&1 &)}
nemo(){(/usr/bin/nemo "$@" > /dev/null 2>&1 &)}
vlc(){(/usr/bin/vlc "$@" > /dev/null 2>&1 &)}
obs(){(/usr/bin/obs "$@" > /dev/null 2>&1 &)}

pipes(){sh /usr/bin/pipes.sh "$@"}

power(){
	PS3="Enter the option: "

	select lng in Shutdown Restart Suspend Logout Quit
	do
		case $lng in
			"Shutdown")
				shutdown -P now
				break
				;;
			"Restart")
				shutdown -r now
				break
				;;
			"Suspend")
				systemctl suspend
				break
				;;
			"Logout")
				if [[ $XDG_CURRENT_DESKTOP = "Hyprland" ]]; then
					hyprctl dispatch exit --
				elif [[ $XDG_CURRENT_DESKTOP = "i3" ]]; then
					i3-msg exit
				else
					return 1
				fi
				break
				;;
			"Quit")
				break ;;
			*)
				echo "Invalid option" ;;
		esac
	done
}

neofetch # I use Arch btw

#
# ~/.zshrc
#
# If not running interactively, don't do anything

[[ $- != *i* ]] && return

#clear

autoload -Uz add-zsh-hook
#autoload -Uz vcs_info

# Title for terminal

function xterm_title_precmd() {

	print -Pn -- '\e]2;%n@%m:%~\a'
	if [[ "$TERM" == 'screen'* ]]; then
		print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
	fi
}

function xterm_title_preexec() {

	print -Pn -- '\e]2;%n@%m:%~ %# '
	print -n -- "${(q)1}\a"

	if [[ "$TERM" == 'screen'* ]]; then
		print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# '
		print -n -- "${(q)1}\e\\"
	fi
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|gnome*|konsole*|\
	              kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

function command_not_found_handler {

    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"

    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )

    if (( ${#entries[@]} )); then

        local pkg

        printf "${bright}$1${reset} may be found in the following packages:\n"

		for entry in "${entries[@]}"; do
			# (repo package version file)
			local fields=( ${(0)entry} )

			if [[ "$pkg" != "${fields[2]}" ]]; then
				printf "${purple}%s/${bright}%s ${green}%s${reset}\n" \
				       "${fields[1]}" "${fields[2]}" "${fields[3]}"
			fi

			printf '    /%s\n' "${fields[4]}"

			pkg="${fields[2]}"

		done
	fi

	return 127
}

bindkey -e
bindkey "^[[3~" delete-char

PLUGINS_DIR=/usr/share/zsh/plugins

source $PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $PLUGINS_DIR/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source $PLUGINS_DIR/zsh-autopair/autopair.zsh

zstyle ':autocomplete:*' key-binding off

### prompt color ###

reset="%f%b"
bold="%B"

col_user="%F{10}" # green
sh_char='$'
if [[ $UID == 0 ]]; then
	col_user="%F{11}" # yellow
	sh_char='#'
fi

col_line="%F{cyan}"

col_cmdnum="%F{15}"
col_err="%F{9}"  # bright red
col_host="%F{12}"
col_at="%F{8}"   # dark gray
col_sh="%F{14}"  # bright cyan
col_pwd="%F{13}" # bright magenta

col_git="%F{#f05033}" # orange

# Command number

[[ $cmdcount -ge 1 ]] || cmdcount=1
preexec() { ((cmdcount++)) }

ZSH_HIGHLIGHT_STYLES[precommand]=fg=11,underline
ZSH_HIGHLIGHT_STYLES[function]=fg=14
ZSH_HIGHLIGHT_STYLES[alias]=fg=13
ZSH_HIGHLIGHT_STYLES[command]=fg=14
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=3
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=3

STARSHIP_LOG="error"

block_cmd_num=$col_line'['$col_cmdnum$bold'$cmdcount'$reset$col_line']'
block_err='%(?,,'$col_line'['$col_err$bold'%?'$reset$col_line'])'

block_user=$col_line'['$bold
block_user+=$col_user'%n' # username
block_user+=$col_at'@'
block_user+=$col_host'%m' # hostname
block_user+=$reset$col_line']'

block_pwd=$col_line'['$col_pwd'%~'$col_line']'

eval "$(atuin init zsh)"
eval "$(thefuck --alias)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"

zle-line-init() {
	emulate -L zsh

	if [[ $CONTEXT != start ]]; then
		return 0
	fi

	while true; do
		zle .recursive-edit
		local -i ret=$?

		if [[ $ret != 0 || $KEYS != $'\4' ]] then
			break
		fi

		if [[ ! -o ignore_eof ]]; then
			exit 0
		fi
	done

	local saved_prompt=$PROMPT
	local saved_rprompt=$RPROMPT

	PROMPT="$bold$col_sh$sh_char$reset "
	RPROMPT=''
	zle .reset-prompt

	PROMPT=$saved_prompt
	RPROMPT=$saved_rprompt

	if (( ret )); then
		zle .send-break
	else
		zle .accept-line
	fi

	return ret
}

zle -N zle-line-init


PROMPT=$col_line'┌─'$block_cmd_num${PROMPT}$col_sh$bold$sh_char$reset" "
#PS1+=$block_cmd_num$block_err'─'$block_user'─'
#PS1+=$block_pwd'$vcs_info_msg_0_'

#PS1+=$'\n' # new line

#PS1+=$col_line'└╼'$reset' '$col_sh$bold$sh_char$reset' '

# Better history

HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000000
SAVEHIST=1000000000

# Use local file only for zsh-autocomplete

# __git_files () { _wanted files expl 'local files' _files }

# Some options

ls(){/usr/bin/eza -A --icons --group-directories-first "$@"}
matrix(){/usr/bin/neo-matrix -D "$@"}

tlauncher(){(java -jar ~/.tlauncher/TLauncher-2.86.jar "$@" > /dev/null 2>&1 &)}
deadcells(){(sh /mnt/d/Dead\ Cells\ Linux/start.sh "$@" > /dev/null 2>&1 &)}
undertale(){(sh /mnt/d/Undertale/start.sh "$@" > /dev/null 2>&1 &)}
gungeon(){(sh /mnt/d/Enter\ the\ Gungeon/start.sh "$@" > /dev/null 2>&1 &)}

brave(){(/usr/bin/brave "$@" > /dev/null 2>&1 &)}
chrome(){(/usr/bin/google-chrome-stable "$@" > /dev/null 2>&1 &)}
chromium(){(/usr/bin/chromium %U "$@" > /dev/null 2>&1 &)}
firefox(){(/usr/bin/firefox "$@" > /dev/null 2>&1 &)}

#vscode(){(/usr/bin/code --no-sandbox --new-window "$@" > /dev/null 2>&1 &)}
mysql-workbench(){(/usr/bin/mysql-workbench "$@" > /dev/null 2>&1 &)}
eclipse(){(/usr/bin/eclipse "$@" > /dev/null 2>&1 &)}
neovim(){(/usr/bin/nvim-qt "$@" > /dev/null 2>&1 &)}
#vi(){/usr/bin/nvim "$@"}
emacs(){
	if [[ "$@" == *"-nw"* ]] || [[ "$@" == *"--no-window-system"* ]] then
		/usr/bin/emacs "$@"
	else; (/usr/bin/emacs "$@" > /dev/null 2>&1 &)
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
				elif [[ $XDG_SESSION_TYPE != "wayland" ]]; then
                    killall xinit
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

fastfetch

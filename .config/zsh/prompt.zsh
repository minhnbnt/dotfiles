STARSHIP_LOG="error"

eval "$(starship init zsh)"

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

if [[ $cmdcount < 1 ]]; then
	cmdcount=1
fi

preexec() { ((cmdcount++)) }

block_cmd_num=$col_line'['$col_cmdnum$bold'$cmdcount'$reset$col_line']'
block_err='%(?,,'$col_line'['$col_err$bold'%?'$reset$col_line'])'

block_user=$col_line'['$bold
block_user+=$col_user'%n' # username
block_user+=$col_at'@'
block_user+=$col_host'%m' # hostname
block_user+=$reset$col_line']'

block_pwd=$col_line'['$col_pwd'%~'$col_line']'

PROMPT=$col_line'┌─'$block_cmd_num${PROMPT}$col_sh$bold$sh_char$reset" "

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

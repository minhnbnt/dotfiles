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
col_sh="%F{14}"  # bright cyan

if [[ $cmdcount < 1 ]]; then
	cmdcount=1
fi

preexec() { ((cmdcount++)) }

block_cmd_num=$col_line'['$col_cmdnum$bold'$cmdcount'$reset$col_line']'
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
	PROMPT="$bold$col_sh$sh_char$reset "

	zle .reset-prompt

	PROMPT=$saved_prompt

	if (( ret )); then
		zle .send-break
	else
		zle .accept-line
	fi

	return ret
}

zle -N zle-line-init

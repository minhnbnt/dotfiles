if (( ! $+commands[starship] )); then
	return
fi

STARSHIP_LOG="error"

eval "$(starship init zsh)"

if [[ $UID == 0 ]]; then
	export SH_CHAR='#'
else
	export SH_CHAR='$'
fi

if [[ $CMD_COUNT < 0 ]]; then
	export CMD_COUNT=0
fi

precmd() {
	printf '\e[5 q'
	((CMD_COUNT++))
}

change-prompt() {

	local saved_prompt=$PROMPT
	local saved_rprompt=$RPROMPT

	PROMPT="%F{14}%B$SH_CHAR%f%b "

	zle .reset-prompt

	PROMPT=$saved_prompt
}

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

	change-prompt

	if (( ret )); then
		zle .send-break
	else
		zle .accept-line
	fi

	return ret
}

zle -N zle-line-init

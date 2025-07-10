compdef _precommand run

if (( $+commands[oniux] )); then
	compdef _precommand oniux
fi

if (( $+commands[podman] )); then
	compdef _podman docker


	if (( $+commands[lazydocker] )); then
		alias lazypodman=lazydocker
	fi
fi

if (( $+commands[conda] )); then
	zinit light conda-incubator/conda-zsh-completion
fi

if (( $+commands[pnpm] )); then
	zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
	zinit light g-plane/pnpm-shell-completion
fi

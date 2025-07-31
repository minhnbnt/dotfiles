compdef _precommand run
run() { "$@" > /dev/null 2>&1 & disown }

lazypodman() {
	DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock lazydocker
}

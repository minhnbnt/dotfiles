compdef _precommand run
run() { "$@" > /dev/null 2>&1 & disown }

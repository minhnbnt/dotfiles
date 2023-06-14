function powermenu {
	option="cancel\nsleep\nlog-out\nshutdown\nrestart"
	selected=$(echo -e $option | dmenu -nb '#000000' -sf '#ffffff' -sb '#285577' -nf '#888888' -fn 'Fira Code Nerd Font-11')
	if [[ $selected = "shutdown" ]]; then
		shutdown -P now
	elif [[ $selected = "restart" ]]; then
		shutdown -r now
	elif [[ $selected = "sleep" ]]; then
		systemctl suspend
	elif [[ $selected = "log-out" ]]; then
		i3-msg exit
	elif [[ $selected = "cancel" ]]; then
		return
	fi
}

powermenu

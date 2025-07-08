ls() { eza -A --icons --group-directories-first --color "$@" }

run() { "$@" > /dev/null 2>&1 & disown }

power() {
	PS3="Enter the option: "

	select option in Shutdown Restart Suspend Logout Quit
	do
		case $option in
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
				;;
			"Quit")
				break ;;
			*)
				echo "Invalid option" ;;
		esac
	done
}

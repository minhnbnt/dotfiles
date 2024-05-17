ls(){/usr/bin/eza -A --icons --group-directories-first --color "$@"}
matrix(){/usr/bin/neo-matrix -D "$@"}

tlauncher(){(java -jar ~/.tlauncher/TLauncher-2.86.jar "$@" > /dev/null 2>&1 &)}
deadcells(){(sh /mnt/d/Dead\ Cells\ Linux/start.sh "$@" > /dev/null 2>&1 &)}
undertale(){(sh /mnt/d/Undertale/start.sh "$@" > /dev/null 2>&1 &)}
gungeon(){(sh /mnt/d/Enter\ the\ Gungeon/start.sh "$@" > /dev/null 2>&1 &)}

brave(){(/usr/bin/brave "$@" > /dev/null 2>&1 &)}
chrome(){(/usr/bin/google-chrome-stable "$@" > /dev/null 2>&1 &)}
chromium(){(/usr/bin/chromium %U "$@" > /dev/null 2>&1 &)}
firefox(){(/usr/bin/firefox "$@" > /dev/null 2>&1 &)}

mysql-workbench(){(/usr/bin/mysql-workbench "$@" > /dev/null 2>&1 &)}
eclipse(){(/usr/bin/eclipse "$@" > /dev/null 2>&1 &)}
neovim(){(/usr/bin/nvim-qt "$@" > /dev/null 2>&1 &)}
vi(){/usr/bin/nvim "$@"}
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

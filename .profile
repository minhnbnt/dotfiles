#
# ~/.profile
#

boot_times=$(last | grep $USER | grep "tty" -c)
echo "$USER logged in ${boot_times} times!"

unset boot_times

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	Hyprland >/dev/null 2>&1
fi

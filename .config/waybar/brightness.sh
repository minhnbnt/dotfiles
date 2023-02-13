current=$(echo "($(light)+0.5)/1" | bc)

while getopts 'id' OPTION; do
	case "$OPTION" in
		i)
			light -S $((current + 10))
			;;
		d)
			light -S $((current - 10))
			;;
	esac
done

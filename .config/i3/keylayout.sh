ibus=$(ibus engine)
xkb=$(setxkbmap -query | grep layout)

switch_engine(){
	if [[ $ibus == "BambooUs" ]]; then
		ibus engine Bamboo
		engine="US"
	else
		ibus engine BambooUs
		engine="VI"
	fi
}

switch_layout(){
	if [[ $xkb == "layout:     us" ]]; then
		setxkbmap jp OADG109A
	else
		setxkbmap us
	fi
}

while getopts 'el' OPTION; do
	case "$OPTION" in
		e)
			switch_engine
			;;
		l)
			switch_layout
			;;
	esac
done

if [[ "${BLOCK_BUTTON}" -eq 3 ]]; then
	switch_layout
fi

if [[ "${BLOCK_BUTTON}" -eq 1 ]]; then
	switch_engine
fi


if [[ $xkb == "layout:     us" ]]; then
	layout='<span color="#9cdcfe">US</span>'
else
	layout="<span>JP</span>"
fi

if [[ $ibus == "BambooUs" ]]; then
	engine='<span>EN</span>'
else
	engine='<span color="#f44747">VI</span>'
fi

echo "$engine $layout"

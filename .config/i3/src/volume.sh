#!/bin/bash
if [[ "$BLOCK_BUTTON" == 3 ]]; then
	pamixer -i 5
	#echo "+5%"
	#sleep 0.5
elif [[ "$BLOCK_BUTTON" == 1 ]]; then
	pamixer -d 5
elif [[ "$BLOCK_BUTTON" == 2 ]]; then
	pamixer -t
fi

if $(pamixer --get-mute); then
	echo ""
	#echo ''
else
	volume=$(pamixer --get-volume)

	#if [ $volume -le 33 ]; the
	#    echo " ${volume}%"
	#elif [ $volume -le 66 ]; then
	#    echo " ${volume}%"
	#else
	#    echo " ${volume}%"
	#fi

	if [[ $volume -le 50 ]]; then
		echo " ${volume}%"
	else
		echo " ${volume}%"
	fi
fi

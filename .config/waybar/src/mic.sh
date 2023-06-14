statusLine=$(amixer get Capture | tail -n 1)
status=$(echo "${statusLine}" | grep -wo "on")
volume=$(echo "${statusLine}" | awk -F ' ' '{print $5}' | tr -d '[]%')

if [[ "${status}" == "on" ]]; then
	echo " ${volume}%"
	#echo " ${volume}%"
	#echo " ${volume}%"
	#echo ""
else
	echo ""
	#echo " "
	#echo ""
	#echo ""
fi

#mode=$(cat ~/.config/i3/cache/powerprofiles)

#if [[ "$BLOCK_BUTTON" == 3 ]]; then
#    mode=${expr $mode + 1}
#elif [[ "$BLOCK_BUTTON" == 1 ]]; then
#    mode=${expr $mode - 1}
#fi
#if [[ $mode = 4 ]]; then
#    mode=1
#     > hello.txt
#    echo "$mode" >> ~/.config/i3/cache/powerprofiles
#elif [[ $mode = 0 ]]; then
#    mode=3
#     > hello.txt
#    echo "$mode" >> ~/.config/i3/cache/powerprofiles
#else
#     > hello.txt
#    echo "$mode" >> ~/.config/i3/cache/powerprofiles
#fi

#!/bin/sh

previousDate=$(date +%s%N | cut -b1-13)
previousStats=$(cat /proc/stat)

sleep 1

currentDate=$(date +%s%N | cut -b1-13)
currentStats=$(cat /proc/stat)

cpus=$(echo "$currentStats" | grep -P 'cpu' | awk -F " " '{print $1}')

for cpu in $cpus
do
	currentLine=$(echo "$currentStats" | grep "$cpu ")
	user=$(echo "$currentLine" | awk -F " " '{print $2}')
	nice=$(echo "$currentLine" | awk -F " " '{print $3}')
	system=$(echo "$currentLine" | awk -F " " '{print $4}')
	idle=$(echo "$currentLine" | awk -F " " '{print $5}')
	iowait=$(echo "$currentLine" | awk -F " " '{print $6}')
	irq=$(echo "$currentLine" | awk -F " " '{print $7}')
	softirq=$(echo "$currentLine" | awk -F " " '{print $8}')
	steal=$(echo "$currentLine" | awk -F " " '{print $9}')
	guest=$(echo "$currentLine" | awk -F " " '{print $10}')
	guest_nice=$(echo "$currentLine" | awk -F " " '{print $11}')

	previousLine=$(echo "$previousStats" | grep "$cpu ")
	prevuser=$(echo "$previousLine" | awk -F " " '{print $2}')
	prevnice=$(echo "$previousLine" | awk -F " " '{print $3}')
	prevsystem=$(echo "$previousLine" | awk -F " " '{print $4}')
	previdle=$(echo "$previousLine" | awk -F " " '{print $5}')
	previowait=$(echo "$previousLine" | awk -F " " '{print $6}')
	previrq=$(echo "$previousLine" | awk -F " " '{print $7}')
	prevsoftirq=$(echo "$previousLine" | awk -F " " '{print $8}')
	prevsteal=$(echo "$previousLine" | awk -F " " '{print $9}')
	prevguest=$(echo "$previousLine" | awk -F " " '{print $10}')
	prevguest_nice=$(echo "$previousLine" | awk -F " " '{print $11}')

	PrevIdle=$((previdle + previowait))
	Idle=$((idle + iowait))

	PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
	NonIdle=$((user + nice + system + irq + softirq + steal))

	PrevTotal=$((PrevIdle + PrevNonIdle))
	Total=$((Idle + NonIdle))

	totald=$((Total - PrevTotal))
	idled=$((Idle - PrevIdle))

	CPU_Percentage=$(awk "BEGIN {print ($totald - $idled)/$totald*100}" | xargs printf "%.*f\n" 1)
	if [[ "$cpu" == "cpu" ]]; then
		usage=$CPU_Percentage%
	fi
done

#profile=(power-saver balanced perfomance)
profile=(power-saver balanced)
state="$HOME/.config/i3/cache/powerstate"

index=$(cat "$state" 2>/dev/null)
nProfile=${#profile[@]}

# Set current index to zero if first time, otherwise next value in sequence
[[ -z "$index" ]] && index=0

if [[ "$BLOCK_BUTTON" == 3 ]]; then
	index=$((++index % nProfile))
	printf "%d\n" $index >"$state"
	powerprofilesctl set ${profile[index]}
	#if [[ "$index" = 0 ]]; then
	#	killall picom
	#else
	#	picom "$@" > /dev/null 2>&1
	#fi
elif [[ "$BLOCK_BUTTON" == 1 ]]; then
	index=$((--index % nProfile))
	printf "%d\n" $index >"$state"
	powerprofilesctl set ${profile[index]}
	#if [[ "$index" = 0 ]];then
	#	killall picom
	#else
	#	picom "$@" > /dev/null 2>&1
	#fi
fi

if [[ "${profile[index]}" = power-saver ]]; then
	icon=
elif [[ "${profile[index]}" = balanced ]]; then
	icon=
else
	icon=
fi

#!/bin/bash
# minhnbnt's first program

F=0
t=$(cat /proc/cpuinfo | grep processor | wc -l)

for ((x=1; x<=$t; x++))
do
	f=$(cat /proc/cpuinfo | grep 'cpu MHz' | sed -n ${x}p  | tr -d '[A-Za-z:]')
	F=$(echo "($F + $f)" | bc)
done

ferq=$(awk "BEGIN {print $F / $t /1000}" | xargs printf "%.*f\n" 2)
echo "${icon} ${ferq}GHz ${usage}"

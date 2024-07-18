#!/bin/bash
# Parse the X window id, the process id, and the process name

window_id=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
pid=$(xprop -id $window_id | grep _NET_WM_PID | awk 'NF>1{print $NF}')
process_name=$(ps -p $pid | grep $pid | awk 'NF>1{print $NF}')

name=$(xprop -id $window_id | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)

if [[ ${#name} = 0 ]]; then
    exit 1
elif [ ${#name} -le 40 ]; then
    echo "$name" || exit 1
else
    echo "${name:0:39}…"|| exit 1
fi

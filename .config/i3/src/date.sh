second=$(date '+%S')

if [[ $second -le 9 ]]; then
    date '+%a %b %d %H:%M:%S'
else
    date '+%H:%M:%S'
fi

#/bin/sh
state="$HOME/.config/i3/cache/lockkey"

num=$(sed -n '1p' < $state | tr -dc '0-9')
caps=$(sed -n '2p' < $state | tr -dc '0-9')
scroll=$(sed -n '3p' < $state | tr -dc '0-9')

while getopts 'ncs:g' OPTION; do
  case "$OPTION" in
    n)
      num=$((++num % 2))
      echo -e "num=$num\ncaps=$caps\nscroll=$scroll" > $state
      ;;
    c)
      caps=$((++caps % 2))
      echo -e "num=$num\ncaps=$caps\nscroll=$scroll" > $state
      ;;
    s)
      scroll=$((++scroll % 2))
      echo -e "num=$num\ncaps=$caps\nscroll=$scroll" > $state  
      ;;
    g)
      if [[ "$num" = 1 ]]; then
        xdotool key Num_Lock
        echo -e "num=1\ncaps=$caps\nscroll=$scroll" > $state
      elif [[ "$caps" = 1 ]]; then
        xdotool key Caps_Lock
        echo -e "num=1\ncaps=1\nscroll=$scroll" > $state
      elif [[ "$scroll" = 1 ]]; then
        xdotool key Scroll_Lock
        echo -e "num=1\ncaps=$caps\nscroll=1" > $state
      fi
      ;;
    #d)
      #if [[ "$num" = 1 ]]; then
      #  x=NUM
      #elif [[ "$caps" = 1 ]]; then
      #  xdotool key Caps_Lock
      #  echo -e "num=1\ncaps=1\nscroll=$scroll" > $state
      #elif [[ "$scroll" = 1 ]]; then
      #  xdotool key Scroll_Lock
      #  echo -e "num=1\ncaps=$caps\nscroll=1" > $state
      #fi
      #;;
    ?)
      echo "script usage: $(basename \$0) [-n] [-c] [-s] [-g]" >&2
      exit 1
      ;;
  esac
done

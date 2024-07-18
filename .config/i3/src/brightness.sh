#!/bin/bash

if [[ "$BLOCK_BUTTON" == 3 ]]; then
    xbacklight -inc 10
elif [[ "$BLOCK_BUTTON" == 1 ]]; then
    xbacklight -dec 10
fi

brightness=$(xbacklight -get)
echo "${brightness%.*}%"

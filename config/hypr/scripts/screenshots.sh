#!/bin/sh

screenshots_dir=~/images/screenshots/

if [ ! -d $screenshots_dir ]; then
	mkdir $screenshots_dir
fi

cd $screenshots_dir && grim -g "$(slurp)"

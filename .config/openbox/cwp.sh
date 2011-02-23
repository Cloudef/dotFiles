#!/bin/sh

# Kill wallpaper.sh
for p in $(pgrep "wallpaper.sh" | sort -n)
do
	kill $p
done

~/.config/openbox/wallpaper.sh
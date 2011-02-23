#!/bin/sh

# Kill wallpaper.sh if there is more than one running
kill=0
for p in $(pgrep "wallpaper.sh" | sort -n)
do
	if [ $kill == 1 ]; then
		kill $p
	fi
	kill=1
done

shopt -s nullglob
 
cd ~/.wallpaper

while true; do
	files=()
	for i in *.jpg *.png; do
		[[ -f $i ]] && files+=("$i")
	done
	range=${#files[@]}

	((range)) && feh --bg-scale "${files[RANDOM % range]}"

	sleep 5m
done
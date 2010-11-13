#!/bin/sh

TRACK="`deadbeef --nowplaying "%t"`"
if [ "$TRACK" = "nothing" ]; then
	exit
fi
ALBUM="`cat ~/.config/deadbeef/nowPlaying | head -n3 | tail -n1`"
ARTIST="`cat ~/.config/deadbeef/nowPlaying | head -n2 | tail -n1`"

if [ ! "`cat ~/.touhou | grep \"$ARTIST - $ALBUM\"`" ]; then
	echo "$ARTIST - $ALBUM" >> ~/.touhou
fi
exit
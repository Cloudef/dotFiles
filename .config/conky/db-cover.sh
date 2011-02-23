#!/bin/bash
# An album art script for Deadbeef

CURCOVER=""
TRACK="`deadbeef --nowplaying "%t"`"
if [ "$TRACK" = "nothing" ]; then
	if [ -f ~/.config/deadbeef/nowPlaying ]; then
		rm ~/.config/deadbeef/nowPlaying
	fi
	exit
fi

if [ -f ~/.config/deadbeef/nowPlaying ]; then
	LTRACK="`cat ~/.config/deadbeef/nowPlaying | head -n1`"
	LALBUM="`cat ~/.config/deadbeef/nowPlaying | head -n3 | tail -n1`"
	CURCOVER="`cat ~/.config/deadbeef/nowPlaying | head -n6 | tail -n1`"
fi

ARTCACHE=~/.config/deadbeef/artcache
if [ ! "$TRACK" = "$LTRACK" ]; then
	ARTIST="`deadbeef --nowplaying "%a"`"
	ALBUM="`deadbeef --nowplaying "%b"`"
	YEAR="`deadbeef --nowplaying "%y"`"
else
	ARTIST="`cat ~/.config/deadbeef/nowPlaying | head -n2 | tail -n1`"
	ALBUM=$LALBUM
	YEAR="`cat ~/.config/deadbeef/nowPlaying | head -n4 | tail -n1`"
fi
ELAPSED="`deadbeef --nowplaying "%e"`"
TIME="`deadbeef --nowplaying "%l"`"
CONKYDIR="$HOME/.config/conky"
COVER="$CONKYDIR/conkyCover.png"

if [ ! "$ALBUM" = "$LALBUM" ]; then
	CURCOVER="`find ${ARTCACHE} -name \"${ALBUM}.jpg\" | head -n 1`"
	if [ ! -f "$CURCOVER" ]; then
	    convert $CONKYDIR/Vinyl/base.png "$COVER" -geometry +4+3
	    #-geometry +0+0 -composite "$COVER"
	else
	    cp "$CURCOVER" "$COVER"
    
	    ASPECT=$((($(identify -format %w "$COVER") - $(identify -format %h "$COVER"))/86))
	    
	    echo "$ASPECT" >> ~/.config/deadbeef/nowPlaying

	    if [ $ASPECT -lt -30 ]; then
		convert "$COVER"  -thumbnail 86x300 "$COVER"
		convert "$COVER" -crop 86x86+0+86 +repage "$COVER"
	    else
		convert "$COVER"  -thumbnail 300x86 "$COVER"
		if [ $ASPECT -lt 30 ]; then
			convert "$COVER" -crop 86x86+0+0 +repage "$COVER"
		else
			convert "$COVER" -crop 86x86+86+0 +repage "$COVER"
		fi
	    fi
	    convert $CONKYDIR/Vinyl/base.png "$COVER" -geometry +4+3
	    # -composite $CONKYDIR/Vinyl/top.png -geometry +0+0 -composite "$COVER"
	fi
fi

eMINUTES="`echo \"$ELAPSED\"|cut -d":" -f1`"
eSECONDS="`echo \"$ELAPSED\"|cut -d":" -f2`"
eMINUTES=$(expr $eMINUTES \* 60 )
eSECONDS=$(expr $eMINUTES + $eSECONDS )

tMINUTES="`echo \"$TIME\"|cut -d":" -f1`"
tSECONDS="`echo \"$TIME\"|cut -d":" -f2`"
tMINUTES=$(expr $tMINUTES \* 60 )
tSECONDS=$(expr $tMINUTES + $tSECONDS )

PERCENT=$(expr \( $eSECONDS \* 100 \) / $tSECONDS )
echo $TRACK &> ~/.config/deadbeef/nowPlaying
echo $ARTIST >> ~/.config/deadbeef/nowPlaying
echo $ALBUM >> ~/.config/deadbeef/nowPlaying
echo $YEAR >> ~/.config/deadbeef/nowPlaying
echo "$ELAPSED/$TIME" >> ~/.config/deadbeef/nowPlaying
echo "$CURCOVER" >> ~/.config/deadbeef/nowPlaying
echo $PERCENT >> ~/.config/deadbeef/nowPlaying
exit

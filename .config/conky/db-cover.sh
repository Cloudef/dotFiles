#!/bin/bash
# An album art script for Deadbeef

# nowPlaying file
# 1. Track
# 2. Artist
# 3. Album
# 4. Year
# 5. Time
# 6. Coverart path
# 7. Time percent
# 8. 1 = Stopped, 0 = Playing

# Make macopix play anim
USE_MACOPIX=1
MACOPIX_ANIM=1
MACOPIX_LOOPS=-1

macopix_play()
{
   if [ $USE_MACOPIX == 1 ]; then
      # start the dance
      macopix --anim $MACOPIX_ANIM --anim-loop $MACOPIX_LOOPS
   fi  
}

macopix_stop()
{
   if [ $USE_MACOPIX == 1 ]; then
      # stop the dance
      macopix --anim-loop 0
   fi          
}

CURCOVER=""
TRACK="`deadbeef --nowplaying "%t"`"
if [ "$TRACK" = "nothing" ]; then
	if [ -f ~/.config/deadbeef/nowPlaying ]; then
		rm ~/.config/deadbeef/nowPlaying
	fi

   # deadbeef closed
   macopix_stop
	exit
fi

if [ ! -f ~/.config/deadbeef/nowPlaying ];then
   # no file yet, this should be called only once in deadbeef's lifetime
   macopix_play
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

   # track changed
   macopix_play # Hopefully it's fixed now
else
	ARTIST="`cat ~/.config/deadbeef/nowPlaying | head -n2 | tail -n1`"
	ALBUM=$LALBUM
	YEAR="`cat ~/.config/deadbeef/nowPlaying | head -n4 | tail -n1`"
   LWTIME="`cat ~/.config/deadbeef/nowPlaying | head -n5 | tail -n1`"
   LPERCENT="`cat ~/.config/deadbeef/nowPlaying | head -n7 | tail -n1`" 
   LSTOP="`cat ~/.config/deadbeef/nowPlaying | head -n8 | tail -n1`"
fi
ELAPSED="`deadbeef --nowplaying "%e"`"
TIME="`deadbeef --nowplaying "%l"`"
CONKYDIR="$HOME/.config/conky"
COVER="$CONKYDIR/conkyCover.png"

if [ ! "$ALBUM" = "$LALBUM" ]; then
	FALBUM="`echo \"${ALBUM}\" | sed \"s/\\//_/g\"`" # Convert all '/' to '_'
	CURCOVER="`find ${ARTCACHE} -name \"${FALBUM}.jpg\" | head -n 1`"
	echo $FALBUM
	if [ ! -f "$CURCOVER" ]; then
	    cp $CONKYDIR/Vinyl/base.png "$COVER"
	else
	    cp "$CURCOVER" "$COVER"
    
	    ASPECT=$((($(identify -format %w "$COVER") - $(identify -format %h "$COVER"))/86))

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
	    # convert $CONKYDIR/Vinyl/base.png "$COVER" -geometry +4+3
	    # -composite $CONKYDIR/Vinyl/top.png -geometry +0+0 -composite "$COVER"
	fi
fi

WTIME="$ELAPSED/$TIME"

if [ ! "$WTIME" = "$LWTIME" ]; then
   eMINUTES="`echo \"$ELAPSED\"|cut -d":" -f1`"
   eSECONDS="`echo \"$ELAPSED\"|cut -d":" -f2`"
   eMINUTES=$(expr $eMINUTES \* 60 )
   eSECONDS=$(expr $eMINUTES + $eSECONDS )

   tMINUTES="`echo \"$TIME\"|cut -d":" -f1`"
   tSECONDS="`echo \"$TIME\"|cut -d":" -f2`"
   tMINUTES=$(expr $tMINUTES \* 60 )
   tSECONDS=$(expr $tMINUTES + $tSECONDS )

   PERCENT=$(expr \( $eSECONDS \* 100 \) / $tSECONDS )

   STOP=0
else
   PERCENT=$LPERCENT
   STOP=1
fi

if [ ! "$STOP" = "$LSTOP" ]; then
   if [ $STOP == 1 ]; then
      # Stopped
      macopix_stop
   else
      # Started
      macopix_play
   fi
fi

echo $TRACK       &> ~/.config/deadbeef/nowPlaying
echo $ARTIST      >> ~/.config/deadbeef/nowPlaying
echo $ALBUM       >> ~/.config/deadbeef/nowPlaying
echo $YEAR        >> ~/.config/deadbeef/nowPlaying
echo $WTIME       >> ~/.config/deadbeef/nowPlaying
echo "$CURCOVER"  >> ~/.config/deadbeef/nowPlaying
echo $PERCENT     >> ~/.config/deadbeef/nowPlaying
echo $STOP        >> ~/.config/deadbeef/nowPlaying 
exit

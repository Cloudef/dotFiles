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

# Coverart settings
CONKYDIR="$HOME/.config/conky"
COVER="$CONKYDIR/conkyCover.png"
ARTCACHE="$HOME/.cache/deadbeef/covers"
NPFILE="$HOME/.config/deadbeef/nowPlaying"

macopix_play() {
   # start the dance
   [ $USE_MACOPIX == 1 ] && macopix --anim $MACOPIX_ANIM --anim-loop $MACOPIX_LOOPS
}

macopix_stop() {
   # stop the dance
   [ $USE_MACOPIX == 1 ] && macopix --anim-loop 0
}

albumart_do() {
   local CURCOVER=
   local LTRACK=
   local LALBUM=
   local ARTIST=
   local ALBUM=
   local YEAR=
   local LWTIME=
   local LPERCENT=
   local LSTOP=
   local STOP=

   local TRACK="$(deadbeef --nowplaying "%t")"
   if [[ "$TRACK" == "nothing" ]]; then
      [ -f "$NPFILE" ] && rm "$NPFILE"

      # deadbeef closed
      macopix_stop
      exit
   fi

   # no file yet, this should be called only once in deadbeef's lifetime
   [ -f "$NPFILE" ] || macopix_play

   # query old information
   if [ -f "$NPFILE" ]; then
      LTRACK="$(head "$NPFILE" -n1)"
      LALBUM="$(head "$NPFILE" -n3     | tail -n1)"
      CURCOVER="$(head "$NPFILE" -n6   | tail -n1)"
   fi

   echo "$TRACK" "$LTRACK"
   if [[ "$TRACK" != "$LTRACK" ]]; then
      ARTIST="$(deadbeef --nowplaying "%a")"
      ALBUM="$(deadbeef --nowplaying "%b")"
      YEAR="$(deadbeef --nowplaying "%y")"

      # track changed
      macopix_play # Hopefully it's fixed now
   else
      ARTIST="$(head "$NPFILE" -n2     | tail -n1)"
      ALBUM=$LALBUM
      YEAR="$(head "$NPFILE" -n4       | tail -n1)"
      LWTIME="$(head "$NPFILE" -n5     | tail -n1)"
      LPERCENT="$(head "$NPFILE" -n7   | tail -n1)"
      LSTOP="$(head "$NPFILE" -n8      | tail -n1)"
   fi

   local ELAPSED="$(deadbeef --nowplaying "%e")"
   local TIME="$(deadbeef --nowplaying "%l")"

   # album changed
   if [[ "$ALBUM" != "$LALBUM" ]]; then
      FALBUM="$(echo "${ALBUM}" | sed "s/\\//_/g")" # Convert all '/' to '_'
      CURCOVER="$(find "${ARTCACHE}" -name "${FALBUM}.jpg" | head -n 1)"
      if [ ! -f "$CURCOVER" ]; then
         cp "$CONKYDIR/base.png" "$COVER"
      else
         cp "$CURCOVER" "$COVER"

         ASPECT=$((($(identify -format %w "$COVER") - $(identify -format %h "$COVER"))/86))
         if [[ $ASPECT -lt -30 ]]; then
            convert "$COVER"  -thumbnail 86x300 "$COVER"
            convert "$COVER" -crop 86x86+0+86 +repage "$COVER"
         else
            convert "$COVER"  -thumbnail 300x86 "$COVER"
            if [[ $ASPECT -lt 30 ]]; then
               convert "$COVER" -crop 86x86+0+0 +repage "$COVER"
            else
               convert "$COVER" -crop 86x86+86+0 +repage "$COVER"
            fi
         fi
      fi
   fi

   local WTIME="$ELAPSED/$TIME"

   # time changed
   if [[ "$WTIME" != "$LWTIME" ]]; then
      eMINUTES="$(echo "$ELAPSED"|cut -d":" -f1)"
      eSECONDS="$(echo "$ELAPSED"|cut -d":" -f2)"
      eMINUTES=$(echo "$eMINUTES * 60" | bc)
      eSECONDS=$(echo "$eMINUTES + $eSECONDS" | bc)

      tMINUTES="$(echo "$TIME"|cut -d":" -f1)"
      tSECONDS="$(echo "$TIME"|cut -d":" -f2)"
      tMINUTES=$(echo "$tMINUTES * 60" | bc)
      tSECONDS=$(echo "$tMINUTES + $tSECONDS" | bc)

      PERCENT=$(echo "($eSECONDS * 100) / $tSECONDS" | bc)
      STOP=0
   else
      PERCENT=$LPERCENT
      STOP=1
   fi

   # state changed
   if [[ "$STOP" != "$LSTOP" ]]; then
      if [[ $STOP -eq 1 ]]; then
         # Stopped
         macopix_stop
      else
         # Started
         macopix_play
      fi
   fi

   echo "$TRACK"        > "$NPFILE.tmp"
   echo "$ARTIST"      >> "$NPFILE.tmp"
   echo "$ALBUM"       >> "$NPFILE.tmp"
   echo "$YEAR"        >> "$NPFILE.tmp"
   echo "$WTIME"       >> "$NPFILE.tmp"
   echo "$CURCOVER"    >> "$NPFILE.tmp"
   echo "$PERCENT"     >> "$NPFILE.tmp"
   echo "$STOP"        >> "$NPFILE.tmp"
   mv "$NPFILE.tmp" "$NPFILE" # so conky doesn't do partial reads
}

albumart_do
exit

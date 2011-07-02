#!/bin/sh

# X
xset s off
xset -dpms
setxkbmap fi
setxkbmap -option terminate:ctrl_alt_bksp

# IBUS
export GTK_IM_MODULE='uim'
export XMODIFIERS=@im='uim'
export QT_IM_MODULE='uim'
uim-xim &
uim-toolbar-gtk-systray &

exec ck-launch-session openbox-session

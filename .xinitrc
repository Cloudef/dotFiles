#!/bin/sh

xset s off
xset -dpms
setxkbmap fi
setxkbmap -option terminate:ctrl_alt_bksp

# UIM
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
uim-xim &
export XMODIFIERS=@im='uim'
uim-toolbar-gtk-systray &

exec openbox-session

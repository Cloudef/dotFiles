#!/bin/sh

# DBUS
if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    eval `dbus-launch --sh-syntax --exit-with-session`
fi

# X
xset s off
xset -dpms
setxkbmap fi
setxkbmap -option terminate:ctrl_alt_bksp

# IBUS
export GTK_IM_MODULE='uim'
export XMODIFIERS=@im='uim'
export QT_IM_MODULE='uim'
(uim-xim &> /dev/null) &
(uim-toolbar-gtk-systray &> /dev/null) &

exec ck-launch-session dwm

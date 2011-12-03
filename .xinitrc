#!/bin/sh

# Argument is fine
WM="$1"
if [[ ! "$WM" ]]; then
   WM="dwm"
fi

# X
xset s off
xset -dpms
setxkbmap fi
setxkbmap -option terminate:ctrl_alt_bksp
xrdb -merge $HOME/.Xresources

# Properiaty shit, that does not work
# nvidia-settings --load-config-only
$HOME/bin/nvidia-load-settings

# IBUS
export GTK_IM_MODULE='uim'
export XMODIFIERS=@im='uim'
export QT_IM_MODULE='uim'
(uim-toolbar-gtk-systray &> /dev/null) &
(uim-xim &> /dev/null) &

exec ck-launch-session dbus-launch --sh-syntax --exit-with-session "$WM"

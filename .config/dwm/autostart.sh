#!/bin/bash

# D-bus
if which dbus-launch >/dev/null 2>&1 && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --sh-syntax --exit-with-session`
fi

# Make GTK apps look and behave how they were set up in the gnome config tools
if test -x /usr/libexec/gnome-settings-daemon >/dev/null; then
  /usr/libexec/gnome-settings-daemon &
elif which gnome-settings-daemon >/dev/null 2>&1; then
  gnome-settings-daemon &
# Make GTK apps look and behave how they were set up in the XFCE config tools
elif which xfce-mcs-manager >/dev/null 2>&1; then
  xfce-mcs-manager n &
fi

# Preload stuff for KDE apps
if which start_kdeinit >/dev/null 2>&1; then
  LD_BIND_NOW=true start_kdeinit --new-startup +kcminit_startup &
fi

# Run XDG autostart things.  By default anything desktop-specific
# See xdg-autostart --help more info
DESKTOP_ENV="OPENBOX"
if which /usr/lib/openbox/xdg-autostart >/dev/null 2>&1; then
  /usr/lib/openbox/xdg-autostart $DESKTOP_ENV
fi

# Turn off dmps and screen blanking
xset -dpms
xset s off

# Set wallpapers
(nitrogen --restore &> /dev/null) &

# Cairo compgmr
(cairo-compmgr &> /dev/null) &

# Redshift
(gtk-redshift -l 62:22 &> /dev/null) &

# Unclutter
(unclutter -idle 5 -jitter 5 &> /dev/null) &

# Clipit
(clipit &> /dev/null) &

# Smart notify
(smart-notifier &> /dev/null) &

# Kupfer
(kupfer &> /dev/null) &

# Conky
(sleep 2 && conky -q -d -c $HOME/.config/conky/db.conky &> /dev/null) &

# Alsa settings back
alsactl restore &

# Cow notify
(sleep 50 && cow-notify &> /dev/null) &

# Hatsune Miku
(sleep 60 && macopix --sockmsg ~/.config/macopix/L-Miku.mcpx &> /dev/null) &

# Dzen
RAM_DWIDTH=100
RAM_WIDTH=60
WLAN_DWIDTH=200
WLAN_WIDTH=170
HEIGHT=10
POSY=1024

FONT="erusfont:size=9"
RAM_ACT='entertitle=uncollapse;leavetitle=collapse'
WLAN_ACT='entertitle=uncollapse;leavetitle=collapse'

ETC_WIDTH=$((${WLAN_WIDTH}+${RAM_WIDTH}))
WIDTH=$((1440-${ETC_WIDTH}))
RAM_X=$WIDTH
WLAN_X=$((${RAM_X}+${RAM_WIDTH}))

(~/.config/dwm/bottom | dzen2 -ta l -h $HEIGHT -fn "$FONT" -x 0 -y $POSY -w $WIDTH -tw $WIDTH -e "") &
(~/.config/dwm/rambar | dzen2 -ta l -l 3 -h $HEIGHT -fn "$FONT" -x $RAM_X -y $POSY -w $RAM_DWIDTH -tw $RAM_WIDTH -sa c -e "$RAM_ACT") &
(~/.config/dwm/wlan   | dzen2 -ta l -l 5 -h $HEIGHT  -fn "$FONT" -x $WLAN_X -y $POSY -tw $WLAN_WIDTH -w $WLAN_DWIDTH -e "$WLAN_ACT") &

#needs sleep, I guess?
sleep 5

# RSS
urxvt -title SnowNews -name SnowNews -e snownews &

# Torrent
urxvt -title rTorrent -name rTorrent -e rtorrent &

# MSN
urxvt -title MSN -name MSN -e irssi --config=~/.irssi/bitlbee &

# Urxvt
urxvt -title IRSSI -name IRSSI -e irssi &

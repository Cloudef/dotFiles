#!/bin/sh

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

# Dropbox
(dropboxd &> /dev/null) &

# Conky
(sleep 2 && conky -q -d -c $HOME/.config/conky/db.conky &> /dev/null) &

# Alsa settings back
alsactl restore &

# Cow notify
(sleep 50 && cow-notify &> /dev/null) &

# Hatsune Miku
(sleep 60 && macopix --sockmsg ~/.config/macopix/L-Miku.mcpx &> /dev/null) &

# Dzen
$HOME/.config/dwm/dzen2 &

#needs sleep, I guess?
sleep 20

# RSS
urxvt -title SnowNews -name SnowNews -e snownews &

# Torrent
urxvt -title rTorrent -name rTorrent -e rtorrent &

# MSN
urxvt -title MSN -name MSN -e irssi --config=~/.irssi/bitlbee &

# Urxvt
urxvt -title IRSSI -name IRSSI -e irssi &

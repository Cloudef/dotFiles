# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.

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
nitrogen --restore

# Cairo compgmr
cairo-compmgr &

# Redshift
gtk-redshift -l 62:22 &

# Panel
xfce4-panel &

# Devmon
( sleep 5 && devmon ) &

# Unclutter
unclutter -idle 5 -jitter 5 &

# Mixer
volti &

# Tray
stalonetray &

# Clipit
clipit &

# Liferea
urxvt -title SnowNews -name SnowNews -e snownews &

# Deluge
urxvt -title rTorrent -name rTorrent -e rtorrent &

# MSN
emesene &

# Urxvt
urxvt -title IRSSI -name IRSSI -e irssi &

# Smart notify
smart-notifier &

# Kupfer
kupfer &

# Tiling
# pytyle &

# Conky
~/.config/conky/start_conky.sh &

# Alsa settings back
alsactl restore &

# Hatsune Miku
(sleep 20 && macopix --sockmsg .config/macopix/L-Miku.mcpx) &

# Cow notify
(sleep 50 && cow-notify) &

#!/bin/sh

# Argument is fine
WM="${1-dwm}"

monster_init() {
    local ff="/tmp/monsterwm.fifo"

    # autostart
    bar "$ff" 0 | dzen2 -h 18 -y 124  -w 1440 -ta l -fn erusfont -e -p &
    bar "$ff" 1 | dzen2 -h 18 -x 1440 -w 1280 -ta l -fn erusfont -e -p &

    # wait for fifo
    while [[ ! -p "$ff" ]]; do sleep 1; done

    # wait for dzen's
    sleep 2

    # execute wm
    monsterwm | tee -a "$ff"

    # cleanup
    [[ -p "$ff" ]] && rm "$ff"
}

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
   for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
   done
   unset f
fi

# Properiaty shit, that does not work
# nvidia-settings --load-config-only
$HOME/bin/nvidia-load-settings &> /dev/null

# X
numlockx on    &> /dev/null
xset s off     &> /dev/null
xset -dpms     &> /dev/null
setxkbmap fi   &> /dev/null
setxkbmap -option terminate:ctrl_alt_bksp &> /dev/null
xrdb -merge $HOME/.Xresources &> /dev/null

# UIM
export GTK_IM_MODULE='uim'
export XMODIFIERS=@im='uim'
export QT_IM_MODULE='uim'
(uim-toolbar-gtk-systray &> /dev/null) &
(uim-xim &> /dev/null) &

# Set wallpaper
nitrogen --restore

[[ "$WM" == monsterwm ]] && monster_init || exec "$WM"

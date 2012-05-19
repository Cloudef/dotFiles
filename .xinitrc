#!/bin/sh

WM="${1-monsterwm}"
export PATH="$HOME/bin:$PATH"

# special route for monsterwm
monsterwm_init() {
   local ff="/tmp/monsterwm.fifo"
   bar "$ff" 0 | dzen2 -h 18 -y 124  -w 980 -ta l -fn erusfont -e -p &
   while [[ ! -p "$ff" ]]; do sleep 1; done; sleep 1
   exec monsterwm | tee -a "$ff"
   [[ -p "$ff" ]] && rm "$ff"
}

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
   for f in /etc/X11/xinit/xinitrc.d/*; do
      [ -x "$f" ] && . "$f"
   done
   unset f
fi

# Set cursor
xsetroot -cursor_name left_ptr &

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

# Etc...
$HOME/.config/monsterwm/dzen2start
(dropboxd &> /dev/null) &
(parcellite &> /dev/null) &
(smart-notifier &> /dev/null) &
(sleep 10 && gtk-redshift -l 62:22 &> /dev/null) &
(sleep 10 && URXVTD IRC irssi) &
(sleep 15 && URXVTD RSS snownews) &
(sleep 10 && URXVTD TORRENT rtorrent) &
ssh_watch &

# Wait for dzen2
while ! killall -0 dzen2; do sleep 1; done; sleep 1
[[ "$WM" == "monsterwm" ]] && monsterwm_init
[[ "$WM" != "monsterwm" ]] && exec $WM &> /dev/null

# Kill
killall dwb        &> /dev/null
killall redshift   &> /dev/null
killall ssh_watch  &> /dev/null
killall dwmstatus  &> /dev/null
killall dwmstatus2 &> /dev/null

# Wait for deadbeef
while killall -0 deadbeef &> /dev/null; do
   deadbeef --quit
   sleep 10
done

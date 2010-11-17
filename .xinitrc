#!/bin/sh

xset s off
xset -dpms
setxkbmap fi
setxkbmap -option terminate:ctrl_alt_bksp

exec ck-launch-session openbox-session


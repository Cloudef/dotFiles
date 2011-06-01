. $HOME/.bashrc

if [[ -z "$DISPLAY" ]] && [[ ! -a "/tmp/.X11-unix/X0" ]] && [[ 
"`whoami`" != "root" ]]; then
  . startx
  logout
fi

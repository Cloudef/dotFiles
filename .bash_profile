. $HOME/.bashrc

if [[ -z "$DISPLAY" ]] && [[ ! -a "/tmp/.X11-unix/X0" ]] && [[
"`whoami`" != "root" ]]; then
  /usr/bin/xinit -- /usr/bin/X -nolisten tcp :0 </dev/null >/dev/null 2>&1
  logout
fi

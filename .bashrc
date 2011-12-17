###########################
## Enviroiment Variables ##
###########################
# DEFAULT PROGRAMS
export EDITOR="vim"
export BROWSER="opera"

# LESS colors for man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ALSA
export SDL_AUDIODRIVER="alsa"

# SDL Head fix
export SDL_VIDEO_FULLSCREEN_HEAD=1

# TTY THEME
export TTY_THEME="console_phraktured"

# $HOME/BIN
export PATH="$HOME/bin:$PATH"

# Compile options
# [ ARM enviroiment will override ]
export CFLAGS="-march=native -mtune=native -O2 -pipe -fstack-protector --param=ssp-buffer-size=4"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="-Wl,--hash-style=gnu -Wl,--as-needed"

# Opera tweaks
export OPERAPLUGINWRAPPER_PRIORITY=0
export OPERA_KEEP_BLOCKED_PLUGIN=1

# Fix JAVA
export _JAVA_AWT_WM_NONREPARENTING=1

# Old GTK Applications
export GDK_USE_XFT=1

################################
## Test for interactive shell ##
################################
if [[ $- != *i* ]] ; then
   # Shell is non-interactive.  Be done now!
   return
fi

######################################
## Keep a desktop system responsive ##
######################################
schedtool -D $$
ionice -c 3 -p $$

##################
## Bash Options ##
##################
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend
shopt -s hostcomplete
shopt -s no_empty_cmd_completion
shopt -s nocaseglob

################
## TTY COLORS ##
################
if [ "$TERM" = "linux" ]; then
   local colors=($(cat "HOME/.Xcolors/$TTY_THEME"| sed 's/#.*//'))
   for index in ${!colors[@]}
   do
          printf '\e]P%x%s' $index ${colors[$index]}
   done
   clear
fi

###############
## LS COLORS ##
###############
eval $( dircolors -b $HOME/.LS_COLORS )

########################
## Includes && Prompt ##
########################
source ${HOME}/.alias      # Aliases
source ${HOME}/.prompt     # Prompt
source ${HOME}/.funcs      # Shell functions
source ${HOME}/.sshagent   # Keeps you from entering SSH password repeateply

PROMPT_COMMAND=prompt

#############
## Startup ##
#############
setcolors
welcome

#############
## ARM Dev ##
#############
export PROJECTS_BASEDIR=/media/Storage/Dev/Pandora

setprj() {
   . /usr/local/angstrom/arm/environment-setup;
   setprj $@
}

_setprj ()
{
   local cur
   _get_comp_words_by_ref cur
   COMPREPLY=()
   if ls $PROJECTS_BASEDIR/${cur}* >/dev/null 2>&1;then
         COMPREPLY=( $(ls -1d $PROJECTS_BASEDIR/${cur}*|sed "s#$PROJECTS_BASEDIR/##") )
   fi
   return 0
}
complete -F _setprj setprj

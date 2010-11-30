
#Naamioidutaan xfce:ksi
export DE="xfce"
export EDITOR="medit"

# c00kiemon5ter (ivan.kanak@gmail.com) ~ under c00kie License
#

# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

#############################
## Put your fun stuff here ##
#############################

# tty color theme
if [ "$TERM" = "linux" ]; then
	## set the theme name
	local THEME=console_phraktured
	## read the theme, remove comments
	local colors=($(cat $HOME/.color_schemes/$THEME | sed 's/#.*//'))
	## apply the colors
	for index in ${!colors[@]}
	do
		printf '\e]P%x%s' $index ${colors[$index]} 
	done
	clear #for background artifacting
fi

source ${HOME}/.alias
source ${HOME}/.funcs
source ${HOME}/.sshagent

if [ "$PS1" ] ; then  
   mkdir -p -m 0700 /dev/cgroup/cpu/user/$$ > /dev/null 2>&1
   echo $$ > /dev/cgroup/cpu/user/$$/tasks
   echo "1" > /dev/cgroup/cpu/user/$$/notify_on_release
fi

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dirspell
shopt -s histappend
shopt -s hostcomplete
shopt -s no_empty_cmd_completion
shopt -s nocaseglob

PROMPT_COMMAND=prompt

setcolors
wazaaa

export PNDSDK="/usr/local/pandora/arm-2009q3"
export PATH="$PATH:$PNDSDK/bin:$PNDSDK/usr/bin"

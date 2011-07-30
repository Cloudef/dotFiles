###########################
## Enviroiment Variables ##
###########################
export EDITOR="vim"
export BROWSER="opera"

export TTY_THEME="console_phraktured"

################################
## Test for interactive shell ##
################################
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

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

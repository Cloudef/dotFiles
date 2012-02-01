# Path to your oh-my-zsh configuration.
ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="crunchplus"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Using ls++, no need for this
DISABLE_LS_COLORS="true"

# Disable auto titling
DISABLE_AUTO_TITLE="true"

# Something to look for when waiting for auto-completition
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git lol archlinux autojump nyan vi-mode zsh-syntax-highlighting)

# Source files
source "$ZSH/oh-my-zsh.sh"
source "$HOME/.shellrc"

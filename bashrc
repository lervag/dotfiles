# Check if already sourced
[ "$already_sourced" ] && return 0
already_sourced=1

# Set environmental variables
export BIBINPUTS=.:~/:
export DOTFILES=$HOME/.dotfiles
export EDITOR="vim"
export HGENCODING="utf-8"
export HISTFILESIZE=200000
export HISTIGNORE="&:exit"
export HISTSIZE=200000
export HOSTNAME="`hostname -s`"
export LESS="-XeR"
export NTNUSRV="login.stud.ntnu.no"
export OPSYS=$(uname)
export PAGER='less'
export PATH=$PATH:$HOME/scripts/bin
export PYTHONPATH=$HOME/scripts/lib
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export TEXMFHOME=$HOME/.texmf
export XEDITOR="vim +%l %f"

# Enable vi mode
set -o vi
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-p":previous-history
bind -m vi-insert "\C-n":next-history
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line

# Set some bash options (ignore errors)
shopt -s globstar 2>/dev/null
shopt -s extglob

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

source $DOTFILES/auto_completions.sh

umask 022           # Default file permissions
ulimit -s unlimited # Set unlimited stack size

# Define some aliases
alias rm="rm -v"
alias mv="mv -i"
alias cp="cp -i"
alias du="du -c"
alias grep="grep -i"
alias l='ls'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias lsa='ls -A'
alias dato='date +"Uke %V, %A %d. %B, %Y -- %T"'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias make='make --no-print-directory'

# Load common functions and local settings
funcs=$DOTFILES/common-functions.sh
[ -f $funcs ] && . $funcs
[ -f $HOME/.bashrc.local ] && . $HOME/.bashrc.local

# Set command prompt and remove CTRL-s and CTRL-q possibility
if [ -t 0 ] && [ -t 1 ]; then
  export PS1='\[\e[1m\]\u@\h:\[\e[34m\]\[\e[1m\]\w\[\e[0m\]> '
  stty stop undef
  stty start undef
fi

# vim: fdm=marker

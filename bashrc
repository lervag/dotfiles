# Bashrc --- Karl Yngve Lervåg
# -----------------------------------------------------------------------------
#
# Check if already sourced
if [ ! "$already_sourced" ]; then
  already_sourced=1
else
  return
fi
#{{{1 Set environmental variables
# Set some environmental variables
export HOSTNAME="`hostname -s`"
export EDITOR="vim"
export XEDITOR="vim +%l %f"
export OPSYS=$(uname)
export HISTSIZE=2000
export HISTFILESIZE=2000
export HGENCODING="latin-1"
export NTNUSRV="login.stud.ntnu.no"
export PATH=$PATH:$HOME/scripts/bin
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export BIBINPUTS=.:~/:
export TEXMFHOME=$HOME/.texmf
export PETSC_DIR=/home/petsc/petsc-current
export HISTIGNORE="&:exit"
export DOTFILES=$HOME/.dotfiles

# Vi mode
set -o vi
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-p":previous-history
bind -m vi-insert "\C-n":next-history
bind -m vi-insert "\C-a":beginning-of-line
bind -m vi-insert "\C-e":end-of-line

# Set some bash options
shopt -s globstar
shopt -s extglob

# Enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

source $DOTFILES/auto_completions.sh

umask 022           # Default file permissions
ulimit -s unlimited # Set stack size limit

#{{{1 Define some aliases
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias du="du -c"
alias grep="grep -i"
alias ls='ls -X --color=auto --group-directories-first'
alias ll='ls -ogh'
alias lsa='ls -A'
alias dato='date +"Uke %V, %A %d. %B, %Y -- %T"'
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias e2n="ssh $NTNUSRV e2n"
alias n2e="ssh $NTNUSRV n2e"
[ ! "`which xpdf 2> /dev/null`" ] && [ "`which kpdf 2> /dev/null`" ] \
  && alias xpdf='kpdf'

#{{{1 Load system settings
sysfile=$DOTFILES/system-specifics.sh
[ -f $sysfile ]   && . $sysfile

#{{{1 Welcome message
if [ -t 0 ] && [ -t 1 ]; then
  if [ ! "$tasks_written" ]; then
    echo "Velkomen til $HOSTNAME! "
    echo "---------------------------------------------------------------------"
    echo
  fi

  # Set a good command prompt
  export PS1='\[\e[1m\]\u@\h:\[\e[34m\]\[\e[1m\]\w\[\e[0m\]> '

  # Remove CTRL-s and CTRL-q possibility
  stty stop undef
  stty start undef
fi
#}}}1

# vim: set foldmethod=marker ff=unix:

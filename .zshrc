# zshrc --- Karl Yngve Lervåg
# -----------------------------------------------------------------------------
#
#{{{1 Set general environmental variables
export HOSTNAME="`hostname -s`"
export EDITOR="vim"
export XEDITOR="vim +%l %f"
export OPSYS=$(uname)
export HISTFILE=$HOME/.zhistory
export HISTSIZE=20000
export SAVEHIST=10000
export HGENCODING="latin-1"
export NTNUSRV="login.stud.ntnu.no"
export PATH=$PATH:$HOME/scripts/bin
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export BIBINPUTS=.:~/:
export TEXMFHOME=$HOME/.texmf
export PETSC_DIR=/home/petsc/petsc-current
export HISTIGNORE="&:exit"  # Ignore some commands in history
export PAGER='less'

#{{{1 Options
#{{{2 General options
# Vi mode in readline
set -o vi

# Default file permissions
umask 022

#{{{2 zsh options
eval `dircolors -b`

unsetopt bgnice

setopt nohup
setopt interactive_comments
setopt extended_history \
       inc_append_history \
       no_bang_hist \
       hist_expire_dups_first \
       hist_reduce_blanks
setopt correct_all
setopt notify
setopt complete_aliases \
       rec_exact
setopt glob_dots \
       extended_glob
setopt longlistjobs
setopt auto_cd \
       cdable_vars \
       auto_list
setopt auto_pushd \
       pushd_ignore_dups \
       pushd_to_home

#{{{2 Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

#{{{2 Add plugins and stuff
autoload -U compinit
autoload -U colors
autoload -U zsh/terminfo
compinit
colors

#{{{2 Set command prompt
ps_blue="%{$terminfo[bold]$fg[blue]%}"
ps_green="%{$terminfo[bold]$fg[green]%}"
ps_red="%{$terminfo[bold]$fg[red]%}"
ps_white="%{$terminfo[bold]$fg[white]%}"
ps_reset="%{$terminfo[sgr0]%}"
export PS1="$ps_blue%n$ps_white@$ps_green%m$ps_reset:$ps_red%3~$ps_reset%(!.#.$) " 
#export RPS1="$PR_LIGHT_YELLOW(%D{%m-%d %H:%M})$PR_NO_COLOR"


#{{{2 Add some keybindings
bindkey ' '    magic-space
bindkey '^I'   expand-or-complete-prefix
bindkey "^R"   history-incremental-search-backward
bindkey "\e[Z" reverse-menu-complete

#{{{2 Autocompletion styles
# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#{{{2 Define aliases
# General aliases
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

# Extension stuff
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s txt=gvim
alias -s tex=gvim

#{{{1 Load system settings
sysfile=~/system_files/zshrc
[ -f $sysfile ] && . $sysfile

#{{{1 Welcome message
echo "Velkomen til $HOSTNAME! "
echo "---------------------------------------------------------------------"
echo

# -----------------------------------------------------------------------------
# vim: set foldmethod=marker ff=unix:

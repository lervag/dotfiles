# zshrc --- Karl Yngve Lervåg
# -----------------------------------------------------------------------------
# Created 2011-06-19

# Check if already sourced
[ "$already_sourced" ] && return 0
already_sourced=1

#{{{1 Set environmental variables

# General
export HOSTNAME=$HOST
export EDITOR="vim"
export XEDITOR="vim +%l %f"
export OPSYS=$(uname)
export HISTSIZE=200000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"
export PATH=$PATH:$HOME/scripts/bin
export PAGER='less'
export LESS="-XeR"
export DOTFILES=$HOME/.dotfiles
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# zsh stuff
fpath=($DOTFILES/zsh-functions $fpath)
fpath=($DOTFILES/zsh-completions/src $fpath)

# Other
export HGENCODING="utf-8"
export NTNUSRV="login.stud.ntnu.no"
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export BIBINPUTS=.:~/:
export TEXMFHOME=$HOME/.texmf
export KEYBOARD_HACK=\'
export CVS_RSH=ssh
eval `dircolors -b $HOME/.dircolors.ansi-dark`

#{{{1 Define aliases and utility functions
# General aliases
alias rm="rm -v"
alias mv="mv -i"
alias cp="cp -i"
alias gcp="rsync -P"
alias du="du -c"
alias grep="egrep -i"
alias s='ls'
alias l='ls'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias lsa='ls -A'
alias dato='date +"Uke %V, %A %d. %B, %Y -- %T"'
alias ..='cd ..'
alias ...='cd ...'
alias cd..='cd ..'
alias e2n="ssh $NTNUSRV e2n"
alias n2e="ssh $NTNUSRV n2e"
[ ! "`which xpdf 2> /dev/null`" ] && [ "`which kpdf 2> /dev/null`" ] \
  && alias xpdf='kpdf'
alias anki='anki -b documents/anki'
alias mupdf='mupdf -r 100'
alias matlab='matlab -nodesktop -nosplash'
alias tmux='TERM=screen-256color-bce tmux'
alias minivim='vim -u ~/.vim/minivimrc'
alias minigvim='gvim -u ~/.vim/minivimrc'
alias make='make --no-print-directory'

# Global aliases
alias -g M='| more'
alias -g N='> /dev/null'

# Extension stuff
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s txt=gvim
alias -s tex=gvim
alias -s pdf=mupdf
alias -s png=eog
alias -s jpg=eog

# Utility functions
c() { python2 -c "from math import *; print $*" | tee >(xsel) }
chpwd() { emulate -L zsh; ls }
cmdfu() {
  curl "http://www.commandlinefu.com/commands/matching/$@/$(echo -n $@ \
    | openssl base64)/plaintext";
}
cvs() {
  if [ "$1" = "diff" ]; then
    shift
    =cvs -q diff -u $*|colordiff|less
  elif [[ "$1" = st* ]]; then
    =cvsutility
  else
    =cvs $*
  fi
}
h()  { history -i $* 1|grep $(date +%F)|cut --complement -c8-18|less }
h2()  { history -i $* 1|grep $(date -d y +%F)|cut --complement -c8-18|less }
highlight() { command egrep --color=always -i -e '^' -e $* }
mount() {
  if ["$1" = ""]; then
    =findmnt -D
  else
    =mount $*
  fi
}

# To get colors in man
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"

#{{{1 Options
umask 022           # Default file permissions
ulimit -s unlimited # Set stack size limit

# Turn on/off some zsh options
setopt always_to_end
setopt auto_cd
setopt auto_list
setopt auto_pushd
setopt auto_param_slash
setopt auto_param_keys
setopt bang_hist
setopt clobber
setopt complete_aliases
setopt complete_in_word
setopt extended_glob
setopt glob_complete
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt interactive_comments
setopt list_rows_first
setopt long_list_jobs
setopt no_case_glob
setopt no_nomatch
setopt nohup
setopt notify
setopt pushd_ignore_dups
setopt pushd_to_home

# Behave more like bash
setopt magic_equal_subst
setopt ksh_typeset

# Autoload zsh modules when they are referenced
zmodload zsh/stat
zmodload zsh/mathfunc
zmodload zsh/complist

# Add plugins and stuff
autoload -U zmv
autoload -U zsh/terminfo
autoload -U compinit
autoload -U colors
compinit -i
colors

#{{{1 Completion styles
# Set some commands to use other command completions
compdef mosh=ssh

# General settings
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select=10
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' list-prompt \
       '%SAt %p, %l: Hit TAB for more or anything else to continue.%s'
zstyle ':completion:*:commands' rehash 1
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# Define completers
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors \
          'reply=$((($#PREFIX+$#SUFFIX)/2))'
zstyle ':completion:*' matcher-list '' '+m:{a-z-}={A-Z_}' \
                                    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Change some formats
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages'     format '%d'
zstyle ':completion:*:warnings'     format 'No matches for: %B%d%b'
zstyle ':completion:*:corrections'  format '%d %B(errors: %e)%b'

# Set tag order for subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Options for kill and other programs that uses the processes tag
zstyle ':completion:*:processes' insert-ids single
zstyle ':completion:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -Hu lervag -o pid,user,cmd'

# Options for tecplot
zstyle ':completion:*:*:tec360:*' file-sort time
zstyle ':completion:*:*:tec360:*' file-patterns \
  '*.{lay,plt,tec}::data\ files' \
  '%p::other\ files'

# Options for manuals
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

# Some control of make completion
zstyle ':completion:*:*:make:*' list-rows-first
zstyle ':completion:*:*:make:*:variables' hidden all
zstyle ':completion:*:*:make:*:targets' ignored-patterns '*.o'

# Define users and hosts for completion
local _users _myhosts
_users=(root $(ls $HOME/..))
_myhosts=(localhost)
if [ -r ~/.ssh/known_hosts ]; then
  _myhosts=("$_myhosts[@]"
    ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}
  )
fi
if [ -r ~/.ssh/config ]; then
  _myhosts=("$_myhosts[@]"
    ${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}
  )
fi
zstyle ':completion:*:*:*' users $_users
zstyle ':completion:*:*:*' hosts $_myhosts

#{{{1 Set command prompt

#{{{2 Helper functions
function gray    { echo "%{$fg[white]%}$*%{$terminfo[sgr0]%}" }
function magenta { echo "%{$fg[yellow]%}$*%{$terminfo[sgr0]%}" }
function blue    { echo "%{$fg[blue]%}$*%{$terminfo[sgr0]%}" }
function cyan    { echo "%{$fg[cyan]%}$*%{$terminfo[sgr0]%}" }

function repo_dir {
  path=$PWD
  while [ "$path" != "" ]; do
    [ -d "$path/$1" ] && return 0
    path=${path%/*}
  done
  return 1
}

function prompt {
  if $(repo_dir ".git"); then
    rp="g"
  else
    rp="-"
  fi
  if $(repo_dir ".hg"); then
    rp+="h"
  else
    rp+="-"
  fi
  if $(repo_dir "CVS"); then
    rp+="c"
  else
    rp+="-"
  fi
  echo "$rp"
}

#{{{2 Set prompt

precmd () {
  local l="%$(( $COLUMNS - 6 - ${#USERNAME} - ${#HOSTNAME} ))<...<"
  local pr="$(gray $(prompt))"
  print -rP "$(magenta %n)$(gray @)$(magenta %m) $(gray in) $(cyan $l%~)"
  PS1="$pr$(magenta '>') "
  PS2="   $(magenta '| %_ >') "
  print -Pn "\e]0;%m: %~\a"
}

#{{{2 Update cursor when changing vi mode
if [[ ! "$TERM" =~ 'linux' ]]; then
  function zle-line-init zle-keymap-select {
    case $KEYMAP in
      (vicmd)      print -n '\e]12;#aa2222\a';;
      (viins|main) print -n '\e]12;#aaaaaa\a';;
    esac
    zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select
fi

#{{{1 Add some keybindings

bindkey -v

# Insert mode
bindkey ' '    magic-space
bindkey "^R"   history-incremental-search-backward
bindkey "^T"   history-incremental-search-forward
bindkey "^U"   backward-kill-line
bindkey "^K"   kill-line
bindkey "^F"   vi-forward-char
bindkey "^B"   vi-backward-char
bindkey "^A"   beginning-of-line
bindkey "^W"   end-of-line
bindkey "\E[Z" reverse-menu-complete
bindkey "^E"   expand-word
bindkey -r    "\e"
bindkey "jk"  "vi-cmd-mode"
bindkey "^X"  execute-named-cmd
bindkey "^W"  where-is
bindkey "^_"  undo
bindkey "\eq" push-line-or-edit
bindkey "^H"  _complete_help
bindkey "\eOH"  beginning-of-line    # Home
bindkey "\eOF"  end-of-line          # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history       # PageDown
bindkey "\e[2~" beginning-of-line    # Ins
bindkey "\e[3~" delete-char          # Del
bindkey "^?"    backward-delete-char # Backspace

# Normal mode
bindkey -a "k" up-line-or-search
bindkey -a "j" down-line-or-search

# Edit line with vim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Type '...' to get '../..' with successive .'s adding /..
function rationalise-dot {
    local MATCH # keep the regex match from leaking to the environment
    if [[ $LBUFFER =~ '(^|/| |      |'$'\n''|\||;|&)\.\.$' ]]; then
      LBUFFER+=/
      zle self-insert
      zle self-insert
    else
      zle self-insert
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

#{{{1 Load system-specific settings
sysfile=$DOTFILES/system-specifics.sh
[ -f $sysfile ] && source $sysfile
#}}}1

# vim: fdm=marker

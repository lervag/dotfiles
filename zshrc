# zshrc --- Karl Yngve Lervåg
# -----------------------------------------------------------------------------
# Created 2011-06-19

# Check if already sourced
[ "$already_sourced" ] && return 0
already_sourced=1

#{{{1 Set environmental variables

# General
export HOSTNAME="`hostname -s`"
export EDITOR="vim"
export XEDITOR="vim +%l %f"
export OPSYS=$(uname)
export HISTSIZE=20000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
export PATH=$PATH:$HOME/scripts/bin
export PAGER='less'
export LESS="-X"
export DOTFILES=$HOME/.dotfiles
export LC_ALL=en_US.utf-8
export LC_NUMERIC=en_US.utf-8
export LANG=en_US.utf-8
export LANGUAGE=en_US.utf-8

# zsh stuff
fpath=($DOTFILES/zsh-functions $fpath)
fpath=($DOTFILES/zsh-completions $fpath)

# Other
export HGENCODING="utf8"
export NTNUSRV="login.stud.ntnu.no"
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export BIBINPUTS=.:~/:
export TEXMFHOME=$HOME/.texmf
export PETSC_DIR=/home/petsc/petsc-current
export KEYBOARD_HACK=\'
eval `dircolors -b $HOME/.dircolors.ansi-dark`

#{{{1 Define aliases
# General aliases
alias rm="rm -v"
alias mv="mv -i"
alias cp="cp -i"
alias du="du -c"
alias grep="egrep -i"
alias s='ls'
alias l='ls'
alias ls='ls -X --color=auto --group-directories-first'
alias ll='ls -ogh'
alias lsa='ls -A'
alias dato='date +"Uke %V, %A %d. %B, %Y -- %T"'
alias ..='cd ..'
alias ...='cd ...'
alias cd..='cd ..'
alias e2n="ssh $NTNUSRV e2n"
alias n2e="ssh $NTNUSRV n2e"
[ ! "`which xpdf 2> /dev/null`" ] && [ "`which kpdf 2> /dev/null`" ] \
  && alias xpdf='kpdf'
alias sudoapt='sudo aptitude update && sudo aptitude upgrade'
alias anki='anki -b documents/anki'

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
mupdf() { command mupdf -r 95 ${*:-*.pdf(om[1]N)} }
evince() { echo "Use mupdf" }
okular() { command okular ${*:-*.pdf(om[1]N)} }
highlight() { command egrep --color=always -i -e '^' -e $* }

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

#{{{1 Autocompletion styles
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
zstyle ':completion:*' list-separator ''
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' list-prompt \
       '%SAt %p, %l: Hit TAB for more or anything else to continue.%s'
zstyle ':completion:*:commands' rehash 1

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
zstyle ':completion:*:*:tecplot:*' file-sort time
zstyle ':completion:*:*:tecplot:*' file-patterns \
  '*.{lay,plt,tec}::data\ files' \
  '%p::other\ files'

# Define some hosts and ignore some users
zstyle ':completion:*' users-hosts \
      lervag@stud.ntnu.no lervag@olve.ivt.ntnu.no \
      lervag@vsl142 lervag@vsl143 \
      klervaag@pluripotent.math.uci.edu \
      klervaag@levich.math.uci.edu \
      klervaag@home.ps.uci.edu \
      hg@bitbucket.org
zstyle ':completion:*:users' ignored-patterns \
      adm amanda apache avahi avahi-autoipd backup beaglidx bin cacti      \
      canna cl-builder clamav couchdb daemon dbus distcache dovecot fax    \
      ftp games gdm gkrellmd gnats gopher hacluster haldaemon halt hplip   \
      hsqldb ident irc junkbust kernoops ldap libuuid list lp mail mailman \
      mailnull man messagebus mldonkey mysql nagios named netdump news     \
      nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix       \
      postgres privoxy proxy pulse pvm quagga radvd rpc rpcuser rpm rtkit  \
      saned shutdown speech-dispatcher squid sshd sync sys syslog usbmux   \
      uucp vcsa www-data xfs Debian-exim Debian-gdm festival statd

zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

#{{{1 Set command prompt

#{{{2 Helper functions
function gray    { echo "%{$fg[white]%}$*%{$terminfo[sgr0]%}" }
function magenta { echo "%{$fg[yellow]%}$*%{$terminfo[sgr0]%}" }
function blue    { echo "%{$fg[blue]%}$*%{$terminfo[sgr0]%}" }
function cyan    { echo "%{$fg[cyan]%}$*%{$terminfo[sgr0]%}" }

function repo_dir {
  while [ "$PWD" != "/" ]; do
    [ -d "$1" ] && return "cvs"
    cd ..
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
[[ ! $TERM = rxvt ]] && print -n '\e]12;#aaaaaa\a'
function zle-line-init zle-keymap-select {
  [[ $TERM = rxvt ]] && return
  case $KEYMAP in
    (vicmd)      print -n '\e]12;#aa2222\a';;
    (viins|main) print -n '\e]12;#aaaaaa\a';;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

#{{{1 Add some keybindings

# Standard or basic bindings
bindkey -v
bindkey ' '    magic-space
bindkey "^R"   history-incremental-search-backward
bindkey "^U"   backward-kill-line
bindkey "^K"   kill-line
bindkey "^F"   vi-forward-char
bindkey "^B"   vi-backward-char
bindkey "^A"   beginning-of-line
bindkey "^W"   end-of-line
bindkey "\E[Z" reverse-menu-complete
bindkey "^E"   expand-word

# Change escape to normal mode
bindkey -r    "\e"
bindkey "jkj" "vi-cmd-mode"

# Some more nice utility widgets
bindkey "^X"  execute-named-cmd
bindkey "^W"  where-is
bindkey "^_"  undo
bindkey "\eq" push-line-or-edit
bindkey "^H"  _complete_help

# Add prediction (but not on as default)
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey '^Xp' predict-on
bindkey '^X^P' predict-off

# Special keys
bindkey "\eOH"  beginning-of-line    # Home
bindkey "\eOF"  end-of-line          # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history       # PageDown
bindkey "\e[2~" beginning-of-line    # Ins
bindkey "\e[3~" delete-char          # Del
bindkey "^?"    backward-delete-char # Backspace

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
sysfile=~/system_files/bashrc.sh
[ -f $sysfile ] && source $sysfile

#{{{1 Load 3rd party plugins
source $DOTFILES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#{{{1 Modeline
# vim: set foldmethod=marker ff=unix:

# zshrc --- Karl Yngve Lervåg
# -----------------------------------------------------------------------------
# Created 2011-06-19
#
# Check if already sourced
if [ ! "$already_sourced" ]; then
  already_sourced=1
else
  return 0
fi
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
eval `dircolors -b $HOME/.dircolors.ansi-dark`

#{{{1 Define aliases
# General aliases
alias rm="rm -v"
alias mv="mv -i"
alias cp="cp -i"
alias du="du -c"
alias grep="grep -i"
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
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] \
  && echo terminal || echo error)" "$(history|tail -n1| \
  sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Extension stuff
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s txt=gvim
alias -s tex=gvim
alias -s pdf=evince
alias -s png=eog
alias -s jpg=eog

# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

# Utility functions
evince() { command evince ${*:-*.pdf(om[1]N)} }
okular() { command okular ${*:-*.pdf(om[1]N)} }

# To get colors in man
alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"

#{{{1 Options
umask 022           # Default file permissions
ulimit -s unlimited # Set stack size limit
watch=( notme )     # Notify all logins or logouts (that are not me)

# Turn on/off some zsh options
unsetopt bgnice
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
compinit
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
zstyle ':completion:*' list-prompt \
       '%SAt %p, %l: Hit TAB for more or character to insert.%s'

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

# Have pdf-files sorted by time for okular and evince
zstyle ':completion:*:*:okular:*' file-sort time
zstyle ':completion:*:*:okular:*' file-patterns \
  '*.pdf:pdf-files:pdf\ files' '*(-/):directories'
zstyle ':completion:*:*:evince:*' file-sort time
zstyle ':completion:*:*:evince:*' file-patterns \
  '*.pdf:pdf-files:pdf\ files' '*(-/):directories'

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
# Define colors
blue="%{$fg[blue]%}"
green="%{$fg[green]%}"
yellow="%{$fg[yellow]%}"
red="%{$fg[red]%}"
white="%{$fg[white]%}"
reset="%{$terminfo[sgr0]%}"
terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]

# Set PS1, PS2
PS1_2="${white}[%(?.$white.$red)%? $yellow%3~${white}]$reset"
PS1_2="%{$terminfo_down_sc$PS1_2$terminfo[rc]%}"
PS1="$PS1_2$yellow%n$white@$green%m$reset%(!.#.$) "
PS2="$PS1_2$yellow%n$white@$green%m$reset:$yellow%_$reset%(!.#.$) "
preexec () { print -rn -- $terminfo[el]; }

# Update RPS1 and RPS2 when changing vi mode (not for term=rxvt)
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
bindkey "^R"   history-incremental-pattern-search-backward
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

#{{{1 Load system-specific settings
sysfile=~/system_files/bashrc.sh
[ -f $sysfile ] && source $sysfile

#{{{1 Load 3rd party plugins
source $DOTFILES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#{{{1 Modeline ----------------------------------------------------------------
# vim: set foldmethod=marker ff=unix:

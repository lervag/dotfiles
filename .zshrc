# zshrc --- Karl Yngve Lervåg
# -----------------------------------------------------------------------------
# Created 2011-06-19
#
# Check if already sourced
if [ ! "$already_sourced" ]; then
  already_sourced=1
else
  return
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
export TERM=rxvt

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
alias mv="mv -iv"
alias cp="cp -iv"
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
setopt nohup
setopt interactive_comments
setopt clobber
setopt extended_history \
       inc_append_history \
       bang_hist \
       hist_verify \
       hist_expire_dups_first \
       hist_ignore_dups \
       hist_reduce_blanks
setopt notify
setopt complete_aliases \
       always_to_end \
       rec_exact
setopt extended_glob
setopt longlistjobs
setopt auto_cd \
       auto_list
setopt auto_pushd \
       pushd_ignore_dups \
       pushd_to_home
setopt no_case_glob

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
#{{{2 Global settings
# Turn on cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Set more verbose output
zstyle ':completion:*' verbose yes

# Remove trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true

# Have all different types of matches displayed separately
zstyle ':completion:*' group-name ''

# Set color specifications
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Set list prompt if completion list fills more than one screen
zstyle ':completion:*' list-prompt \
       '%SAt %p, %l: Hit TAB for more or character to insert.%s'

# Set completer functions
zstyle ':completion:*' completer _complete _match _approximate

# Fuzzy matching of completions for when you mistype them
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors \
          'reply=($((($#PREFIX+$#SUFFIX)/2)) numeric)'

# Case-insensitive and fuzzy completion
zstyle ':completion:*' matcher-list '+m:{a-zA-Z}={A-Za-z}' \
                                    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

#{{{2 Program specific settings
# Have pdf-files sorted by time for okular and evince
zstyle ':completion:*:*:okular:*' file-sort time
zstyle ':completion:*:*:okular:*' file-patterns \
  '*.pdf:pdf-files:pdf\ files' \
  '%p:all-files:all\ files'
zstyle ':completion:*:*:evince:*' file-sort time
zstyle ':completion:*:*:evince:*' file-patterns \
  '*.pdf:pdf-files:pdf\ files' \
  '%p:all-files:all\ files'

# Options for kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' \
         command 'ps --forest -u lervag -o pid,user,cmd'

# cd wil never select parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Options for tecplot
zstyle ':completion:*:*:tecplot:*' file-sort time
zstyle ':completion:*:*:tecplot:*' file-patterns \
  '*.{lay,plt,tec}::data\ files' \
  '%p::other\ files'

#{{{2 Ignore uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
      adm amanda apache avahi avahi-autoipd backup beaglidx bin cacti      \
      canna cl-builder clamav couchdb daemon dbus distcache dovecot fax    \
      ftp games gdm gkrellmd gnats gopher hacluster haldaemon halt hplip   \
      hsqldb ident irc junkbust kernoops ldap libuuid list lp mail mailman \
      mailnull man messagebus mldonkey mysql nagios named netdump news     \
      nfsnobody nobody nscd ntp nut nx openvpn operator pcap postfix       \
      postgres privoxy proxy pulse pvm quagga radvd rpc rpcuser rpm rtkit  \
      saned shutdown speech-dispatcher squid sshd sync sys syslog usbmux   \
      uucp vcsa www-data xfs

#{{{2 Unprocessed
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:processes-names' command 'ps axho command'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

#{{{1 Set command prompt
# Define colors
blue="%{$fg[blue]%}"
green="%{$fg[green]%}"
yellow="%{$fg[yellow]%}"
red="%{$fg[red]%}"
white="%{$fg[white]%}"
reset="%{$terminfo[sgr0]%}"

# Set PS1, PS2, RPS1 and RPS2
PS1="$yellow%n$white@$green%m$reset%(!.#.$) "
PS2="$yellow%n$white@$green%m$reset:$yellow%_$reset%(!.#.$) "
RPS1="${white}[$yellow%~ %(?.$white.$red)%?${white}]$reset"
RPS2="${white}[$yellow%~ %(?.$white.$red)%?${white}]$reset"

# Update RPS1 and RPS2 when changing vi mode
print -n '\e]12;#aaaaaa\a'
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    (vicmd)      print -n '\e]12;#aa2222\a';;
    (viins|main) print -n '\e]12;#aaaaaa\a';;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

#{{{1 Add some keybindings
bindkey -v
bindkey ' '    magic-space
bindkey "^R"   history-incremental-pattern-search-backward
bindkey "^X"   history-incremental-pattern-search-forward
bindkey "^U"   backward-kill-line
bindkey "^K"   kill-line
bindkey "^F"   vi-forward-char
bindkey "^B"   vi-backward-char
bindkey "^A"   beginning-of-line
bindkey "^E"   end-of-line
bindkey "\E[Z" reverse-menu-complete

# Edit line with vim
autoload    edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Special keys
bindkey "\eOH"  beginning-of-line    # Home
bindkey "\eOF"  end-of-line          # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history       # PageDown
bindkey "\e[2~" beginning-of-line    # Ins
bindkey "\e[3~" delete-char          # Del
bindkey "^?"    backward-delete-char # Backspace

# Change escape to normal mode
bindkey -r "\e"
bindkey "jkj" "vi-cmd-mode"

# Some more additions
bindkey "\eq" push-line-or-edit

# On slow infrastructure where tab-completion takes a while?
# Show "waiting dots" while something tab-completes.
expand-or-complete-with-dots() {
  echo -n " \e[31m...\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

#{{{1 Load system-specific settings
sysfile=~/system_files/bashrc.sh
[ -f $sysfile ] && source $sysfile

#{{{1 Modeline ----------------------------------------------------------------
# vim: set foldmethod=marker ff=unix:

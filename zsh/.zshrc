[ "$already_sourced" ] && return 0
already_sourced=1

# For profiling:
# zmodload zsh/zprof # first
# zprof > "$HOME/prof_$(date +%H_%M_%S).log" # put on last line

#{{{1 Set environmental variables

source $HOME/.profile

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=200000
export KEYBOARD_HACK=\'

# Ruby
if [ -d ~/.gem/ruby ]; then
  local ruby
  for ruby in $(ls -d ~/.gem/ruby/* 2>/dev/null); do
    export PATH=$PATH:$ruby/bin
  done
fi

# Other
eval `dircolors -b $HOME/.dircolors.ansi-dark`

#{{{1 Aliases

# General aliases
alias rm="rm -v"
alias mv="mv -i"
alias cp="cp -i"
alias du="du -c"
alias l='ls'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias anki='anki -b documents/anki'
alias mupdf='mupdf -r 100'
alias mux='tmuxinator'
alias make='make --no-print-directory'
alias xx='atool -x'
alias diff='diff -W $(( $(tput cols) - 2 ))'
alias sdiff='sdiff -w $(( $(tput cols) - 2 ))'

if command -v nvim &>/dev/null; then
  export MANPAGER="nvim +Man!"
else
  alias man="TERMINFO=~/.terminfo/ LESS=c TERM=mostlike PAGER=less man"
fi

# Extension based commands
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s txt=gvim
alias -s tex=gvim
alias -s pdf=zathura
alias -s png=feh
alias -s jpg=feh

#{{{1 Utility functions

take() {
  mkdir -p $@ && cd ${@:$#}
}

info() {
  nvim -c "Info "$@"" -c "wincmd o"
}

h() {
  history -n -i $* 1 | grep $(date +%F) | less
}

mount() {
  if [ "$1" = "" ]; then
    =findmnt -D
  else
    =mount $*
  fi
}

z() {
  pdf=$(fd -t f -e pdf . ~/.local/zotero | fzf -m -d '/' --with-nth=-1)
  if [ -f "$pdf" ]; then
    echo ${pdf#*zotero/storage/}
    zathura $pdf &
  fi
}


#{{{1 Options

# Load some custom zsh functions, e.g. for completion
fpath=($HOME/.local/zsh-functions $fpath)
fpath=($DOTFILES/zsh/zsh-functions $fpath)
fpath=($DOTFILES/zsh/zsh-completions/src $fpath)

# Set default file permissions
umask 022

# Set stack size limit
ulimit -s unlimited

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
setopt hist_ignore_space
setopt hist_reduce_blanks
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

# Load completion module; ensure zcompdump is only flushed once a day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
  touch ~/.zcompdump
else
  compinit -C
fi

# Add plugins and stuff
autoload -U zmv
autoload -U zsh/terminfo
autoload -U colors
colors

#{{{1 Completion styles

# Set some commands to use other command completions
compdef nman=man

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

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

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

#{{{1 Set up vi mode and cursor

bindkey -v

export KEYTIMEOUT=15
insertmode () {
  print -n '\e]12;#cccccc\a'
  print -n '\e[6 q'
}
normalmode () {
  print -n '\e]12;#b58900\a'
  print -n '\e[2 q'
}

# Update cursor when changing vi mode
if [[ ! "$TERM" =~ 'linux' ]]; then
  function zle-line-init zle-keymap-select {
    case $KEYMAP in
      (vicmd)      normalmode;;
      (viins|main) insertmode;;
    esac
  }
  zle -N zle-line-init
  zle -N zle-keymap-select
fi

#{{{1 Add some keybindings

# Insert mode
bindkey -r      "\e"
bindkey ' '     magic-space
bindkey "^R"    history-incremental-pattern-search-backward
bindkey "^T"    history-incremental-pattern-search-forward
bindkey "^U"    backward-kill-line
bindkey "^K"    kill-line
bindkey "^F"    vi-forward-char
bindkey "^B"    vi-backward-char
bindkey "^A"    beginning-of-line
bindkey "^O"    accept-line-and-down-history
bindkey "^P"    accept-and-hold
bindkey "^W"    end-of-line
bindkey "^E"    expand-word
bindkey "^_"    undo
bindkey "jk"    vi-cmd-mode
bindkey "^?"    backward-delete-char # Backspace
bindkey "^X^X"  execute-named-cmd
bindkey "^X^W"  where-is
bindkey "^X^H"  _complete_help
bindkey "\eq"   push-line-or-edit
bindkey "\eOH"  beginning-of-line    # Home
bindkey "\eOF"  end-of-line          # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history       # PageDown
bindkey "\e[2~" beginning-of-line    # Ins
bindkey "\e[3~" delete-char          # Del
bindkey "\e."   insert-last-word     # Alt+.
bindkey "\e,"   copy-prev-shell-word # Alt+,

# Normal mode
bindkey -a "k" up-line-or-search
bindkey -a "j" down-line-or-search

# Handle some special keys
# See also .Xresources for urxvt keysyms
bindkey "\e[32;2u" magic-space
bindkey "\e[32;5u" magic-space
bindkey "\e[32;6u" magic-space
bindkey "\e[Z" reverse-menu-complete
bindkey "\e[9;5u" fzf-completion
bindkey "\e[9;6u" reverse-menu-complete
bindkey "\e[13;2u" accept-line
bindkey "\e[13;5u" accept-line
bindkey "\e[13;6u" accept-line

# Edit line with vim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Paste from clipboard
paste-from-clipboard () { LBUFFER=$LBUFFER$(xsel -o -p </dev/null); }
zle -N paste-from-clipboard
bindkey "^Y" paste-from-clipboard

#{{{1 Set command prompt

if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  function gray    { echo "%{$fg[gray]%}$*%{$terminfo[sgr0]%}" }
  function magenta { echo "%{$fg[yellow]%}$*%{$terminfo[sgr0]%}" }
  function cyan    { echo "%{$fg[cyan]%}$*%{$terminfo[sgr0]%}" }
  function green   { echo "%{$fg[green]%}$*%{$terminfo[sgr0]%}" }
  PS1="$(magenta %n)$(gray @)$(magenta %m)$(gray :) $(cyan $l%~)$(green '❯') "
fi

#{{{1 Load system-specific settings

sysfiles=(
  $DOTFILES/bash/common-functions.sh
  $HOME/.zshrc.local
  "/usr/share/fzf/key-bindings.zsh"
  "/usr/share/fzf/completion.zsh"
  $HOME/.dotfiles/fzf/fzf-history-widget.zsh
  )

for file in $sysfiles[@]; do
  [ -r $file ] && source $file
done

#}}}1

# Welcome message for login shells
if [[ $SHLVL -le 2 && -z "$TMUX" ]] && command -v ls-session >/dev/null ; then
  ls-sessions
fi

# vim: fdm=marker

# Check if already sourced
[ "$already_sourced" ] && return 0
already_sourced=1

#{{{1 Set environmental variables

source $HOME/.dotfiles/profile

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
alias grep="egrep -i"
alias l='ls'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias ..='cd ..'
alias ...='cd ...'
alias cd..='cd ..'
alias anki='anki -b documents/anki'
alias mupdf='mupdf -r 100'
alias tmux='TERM=screen-256color-bce tmux'
alias make='make --no-print-directory'
alias xx='atool -x'
alias info='info --vi-keys'

if command -v nvim >/dev/null 2>&1; then
  export MANPAGER="nvim +'set ft=man' -"
else
  alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"
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

# {{{1 Utility functions

c() {
  print - $(( $* ))
}

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

h() {
  history -n -i $* 1 | grep $(date +%F) | less
}

h2() {
  history -n -i $* 1 | grep $(date +%F -d yesterday) | less
}

mount() {
  if [ "$1" = "" ]; then
    =findmnt -D
  else
    =mount $*
  fi
}

vimpipe() {
  vim - -es '+1' "+$*" '+%print' '+:qa!' | tail -n +2
}

#{{{1 Options

# Load some custom zsh functions, e.g. for completion
fpath=($DOTFILES/zsh-functions $fpath)
fpath=($DOTFILES/zsh-completions/src $fpath)

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

# Load completion modules
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit -i
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
function gray    { echo "%{$fg[gray]%}$*%{$terminfo[sgr0]%}" }
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
bindkey "^R"   history-incremental-pattern-search-backward
bindkey "^T"   history-incremental-pattern-search-forward
bindkey "^U"   backward-kill-line
bindkey "^K"   kill-line
bindkey "^F"   vi-forward-char
bindkey "^B"   vi-backward-char
bindkey "^A"   beginning-of-line
bindkey "^W"   end-of-line
bindkey "\E[Z" reverse-menu-complete
bindkey "^E"   expand-word
bindkey -r    "\e"
bindkey "^_"  undo
bindkey "jk"  "vi-cmd-mode"
bindkey "^X^X"  execute-named-cmd
bindkey "^X^W"  where-is
bindkey "^X^H"  _complete_help
bindkey "\eq" push-line-or-edit
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

sysfiles=(
  $DOTFILES/common-functions.sh
  $HOME/.zshrc.local
  $HOME/.vim/bundle/neoman.vim/scripts/vim.zsh
  $DOTFILES/zsh-functions/pip.zsh
  /usr/bin/virtualenvwrapper_lazy.sh
  )
for file in $sysfiles[@]; do
  [ -r $file ] && source $file
done

#}}}1

# Welcome message for login shells
if [[ $SHLVL -eq 1 && -z "$TMUX" ]] ; then
  ls-sessions
fi

# vim: fdm=marker

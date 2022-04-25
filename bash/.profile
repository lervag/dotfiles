export BIBINPUTS=.:~/:
export CVS_RSH=ssh
export DOTFILES=$HOME/.dotfiles
export EDITOR="nvim"
export GOPATH="$HOME/.cache/go"
export HGENCODING="utf-8"
export HOSTNAME=$HOST
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LESS="-eFRX"
export NVIM_LOG_FILE="$HOME/.cache/nvim/log"
export PAGER='less'
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/scripts/bin:$PATH
export PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH=$HOME/scripts/lib
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export SAVEHIST=200000
export SHELLCHECK_OPTS="-e SC2034 -e SC1090"
export TERM='xterm-256color'
export TEXMFHOME=$HOME/.texmf
export XEDITOR="vim +%l %f"
export GPG_TTY=$(tty)

_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  # Solarized Dark color scheme for fzf
  # export FZF_DEFAULT_OPTS="
  #   --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
  #   --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  # "
  # Solarized Light color scheme for fzf
  export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
  "
}
_gen_fzf_default_opts

if command -v fd >/dev/null; then
  export FZF_DEFAULT_COMMAND="fd -I -L -E tags --type f"
fi
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --height 90% --reverse --info=inline"
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --exact --tiebreak=length,end"
export FZF_DEFAULT_OPTS

stty -ixon

[ -r "$HOME/.profile.local" ] && source "$HOME/.profile.local"

# vim: ft=sh

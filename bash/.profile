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

source "$DOTFILES/fzf/fzf-options.sh"
[ -r "$HOME/.profile.local" ] && source "$HOME/.profile.local"

stty -ixon

# vim: ft=sh

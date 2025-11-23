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
export TEXMFHOME=$HOME/.texmf
export XEDITOR="vim +%l %f"
GPG_TTY=$(tty)
export GPG_TTY

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Flytt en del filer inn i XDG-kataloger
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

source "$DOTFILES/fzf/fzf-options.sh"
[ -r "$HOME/.profile.local" ] && source "$HOME/.profile.local"

stty -ixon

# vim: ft=sh

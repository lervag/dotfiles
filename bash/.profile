export BIBINPUTS=.:~/:
export CVS_RSH=ssh
export DOTFILES=$HOME/.dotfiles
export EDITOR="vim"
export HGENCODING="utf-8"
export HOSTNAME=$HOST
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LESS="-eFRX"
export PAGER='less'
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/scripts/bin
export PYTHONPATH=$HOME/scripts/lib
export RUBYLIB=$RUBYLIB:$HOME/scripts/lib
export SAVEHIST=200000
export TEXMFHOME=$HOME/.texmf
export XEDITOR="vim +%l %f"
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PYTHONDONTWRITEBYTECODE=1
export SHELLCHECK_OPTS="-e SC2034 -e SC1090"

stty -ixon

# vim: ft=sh

#
# This is a list of common initialization functions
#

# Define utility functions
function load_compiler_pgf {
  # Path to compiler is parameter 1
  PGI=$1
  if [ -d $PGI ]; then
    # Version is parameter 2
    pgi=$PGI/linux86/$2
    pgi_64=$PGI/linux86-64/$2
    if [ -d $pgi ] || [ -d $pgi_64 ]; then
      export PGI
      export LM_LICENSE_FILE=$LM_LICENSE_FILE:$PGI/license.dat
      if [ -d $pgi_64 ]; then
        MANPATH=$pgi_64/man:$MANPATH
        PATH=$pgi_64/bin:$PATH
      else
        MANPATH=$pgi/man:$MANPATH
        PATH=$pgi/bin:$PATH
      fi
      export MANPATH
      export PATH
    else
      echo "Error! Could not either of:"
      echo "* $pgi"
      echo "* $pgi_64"
    fi
  else
    echo "Error! Could not find: $PGI"
  fi
}
function load_compiler_gfortran {
  export G95_FPU_INVALID=T
  export G95_FPU_OVERFLOW=T
  export G95_FPU_ZERODIV=T
}
function load_plot_on_runtime {
  qwtpath=$1
  if [ -d $qwtpath ]; then
    export CMAKE_LIBRARY_PATH=$CMAKE_LIBRARY_PATH:$qwtpath/lib
    export CMAKE_INCLUDE_PATH=$CMAKE_INCLUDE_PATH:$qwtpath/include
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$qwtpath/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/koder/plot_on_runtime/lib
  else
    echo "Error: Could not find qwt!"
  fi
}
function load_pencil {
  if [ -d "$1" ]; then
    export PENCIL_HOME=$1
    _sourceme_quiet=1; . $PENCIL_HOME/sourceme.sh; unset _sourceme_quiet
  fi
}
function load_tecplot {
tecplot=$1
mesa=$2
if [ -d $tecplot ]; then
  export TEC360HOME=$tecplot
  export PATH=$PATH:$TEC360HOME/bin
  export TECPHYFILE=$HOME/.tecplot.phy
  unset TECADDONFILE
  alias rlmstat='rlmutil rlmstat -c $TEC360HOME/tecplotlm.lic -a|grep "handle"'
  [ "$mesa" ] && alias tecplot="tec360 -mesa"
fi
}
function load_zsh_highlighting {
  [ -z "$ZSH_NAME" ] && return
  source $DOTFILES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
  ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
  ZSH_HIGHLIGHT_STYLES[alias]='fg=green,underline'
}


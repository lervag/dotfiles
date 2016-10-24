# System specific settings

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

# Next define the system specific settings based on HOSTNAME
if [[ $HOSTNAME = vsl136 ]]; then
  load_compiler_gfortran
  load_compiler_pgf       /opt/pgi 2016
  load_tecplot            /opt/tecplot/tec360
  load_pencil             $HOME/codes/pencil-code
  load_zsh_highlighting

  # Load pFUnit
  export PFUNIT=/opt/pfunit

elif [[ $HOSTNAME = vsl142 ]]; then
  load_compiler_gfortran
  load_compiler_pgf      /usr/local/pgi 2016
  load_tecplot           /usr/local/linux/tecplot/tec360_2013

  # Load intel compiler
  source /usr/local/linux/intel/load_intel_compiler.sh

elif [[ $HOSTNAME = vsl143 || $HOSTNAME = vsl144 ]]; then
  load_compiler_gfortran
  load_compiler_pgf      /usr/local/pgi 2016
  load_tecplot           /usr/local/linux/tecplot/tec360_2013

elif [[ $HOSTNAME = vsl176 ]]; then
  alias ls='ls --color'
  load_compiler_gfortran

  if shopt -q login_shell; then
    #
    # Load modules for the clustervision cluster
    #
    module load torque
    module load maui
    module load gcc/5.1.0
    module load mvapich2/2.1
    module load petsc/mvapich2/gcc/current

    #
    # Use local screen socket dir and list active screens
    #
    export SCREENDIR=/home/vsl175/a/lervag/.screen
    screen -ls |grep -v "No Sockets|^\s*$"
  else
    source /etc/profile.d/modules.sh
  fi

elif [[ $HOSTNAME = "unity.sintef.no" ]]; then

  #
  # Load modules for the clustervision cluster
  #
  export FPATH=${(j/:/)fpath}
  if [[ $- == *i* ]]; then
    module load gcc
    module load intelcomp
    module switch rocks-openmpi openmpi/intel
    module load petsc
    module load python
    module load anaconda3
  fi

elif [[ $HOSTNAME = yoga ]]; then
  load_zsh_highlighting

fi

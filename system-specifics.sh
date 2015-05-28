# System specific settings

# Define utility functions
#{{{1 Utility load functions
#{{{2 Portland group (PGF)
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
#{{{2 Intel
function load_compiler_intel {
  # Path to intel compiler script is given as input
  scriptpath=$1
  old=$scriptpath/bin/ifortvars.sh
  new=$scriptpath/bin/compilervars.sh
  if [ -e $new ]; then
    source $new intel64 2>/dev/null
  elif [ -e $old ]; then
    source $old intel64 2>/dev/null
  else
    echo "Error! Could not find '$scriptpath'"
  fi
}
#{{{2 gfortran
function load_compiler_gfortran {
  # Simply set some options
  export G95_FPU_INVALID=T
  export G95_FPU_OVERFLOW=T
  export G95_FPU_ZERODIV=T
}
#{{{2 sunf90
function load_compiler_sunf90 {
  # Path to sun compiler is given as input
  sun_path=$1
  if [ -d $sun_path ]; then
    export PATH=$PATH:$sun_path/bin
    export MANPATH=$MANPATH:$sun_path/man
  else
    echo "Error! Could not find '$sun_path'"
  fi
}
#{{{2 Plot on runtime
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
#{{{2 SpiderI
function load_spiderI {
  export SPIDER=$1
  export SPILIB=$SPIDER/libs
  export SPILIZ=$SPIDER/lizard
  export PATH=$PATH:$SPIDER/scripts:$SPIDER/lizard/bin
}
#{{{2 SpiderII
function load_spiderII {
  export SPIDERII=$1
  export SPIDERII_LIB=$SPIDERII/libs
  export SPIDERII_LIZ=$SPIDERII/lizard
  export PATH=$PATH:$SPIDERII/scripts
  alias spi1='cd $SPIDERII'
  alias spi2='cd $SPIDERII/source'
  alias spi3='cd $SPIDERII/samples'
}
#{{{2 Pencil code
function load_pencil {
  export PENCIL_HOME=$1
  _sourceme_quiet=1; . $PENCIL_HOME/sourceme.sh; unset _sourceme_quiet
}
#{{{2 Tecplot settings
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
#{{{2 Zsh highlighting
function load_zsh_highlighting {
  [ -z "$ZSH_NAME" ] && return
  source $DOTFILES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
  ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
  ZSH_HIGHLIGHT_STYLES[alias]='fg=green,underline'
}
#{{{2 Maple
function load_maple {
maplepath=$1
if [ -d $maplepath ]; then
  export MAPLEHOME=$maplepath
  export PATH=$PATH:$MAPLEHOME/bin
  alias maple=xmaple
fi
}
#{{{2 Sage
function load_sage {
  sagepath=$1
  [ -d $sagepath ] && export PATH=$PATH:$sagepath
}
#{{{2 TeX Live
function load_texlive {
  texlivepath=$1
  [ -d $texlivepath ] && export PATH=$texlivepath:$PATH
}
#}}}1

# Next define the system specific settings based on HOSTNAME
if [[ $HOSTNAME = vsl136 ]]; then
  load_compiler_gfortran
  load_compiler_sunf90    /opt/oracle/solarisstudio12.3
  load_compiler_pgf       /opt/pgi 2015
  load_tecplot            /opt/tecplot/tec360
  load_pencil             $HOME/codes/pencil-code
  load_zsh_highlighting

  # Load pFUnit
  export PFUNIT=/opt/pfunit

elif [[ $HOSTNAME = vsl142 || \
        $HOSTNAME = vsl143 || \
        $HOSTNAME = vsl144 ]]; then
  load_compiler_gfortran
  load_compiler_intel    /usr/local/linux/intel/fc_2013_sp1
  load_compiler_sunf90   /usr/local/linux/sun/solarisstudio12.3
  load_compiler_pgf      /usr/local/pgi 2015
  load_tecplot           /usr/local/linux/tecplot/tec360_2013

elif [[ $HOSTNAME = vsl176 ]]; then
  alias ls='ls --color'
  load_compiler_gfortran

  #
  # Load modules for the clustervision cluster
  #
  module load torque maui
  module load gcc/5.1.0
  module load mvapich2/2.1
  module load petsc/mvapich2/gcc/3.5.3

elif [[ $HOSTNAME = yoga ]]; then
  load_zsh_highlighting

fi

# vim: fdm=marker

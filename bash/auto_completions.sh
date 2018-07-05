# Check if we use the bash shell
[ ! "$SHELL" = "BASH" ] && return

# Complete functions
_makefile()
{
  COMREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local opts=$(make -qsp 2>/dev/null    | \
         egrep -o "^[a-z][^[:space:]]*::?" | \
         sed 's/::\?//')
  local opts=${opts//"makefile"}
  if [[ ${cur} == * ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
  fi
}
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}

# Set up complete commands
complete -o default -F _pip_completion pip
complete -F _makefile make
complete -W "$(echo $(grep '^ssh ' ~/.bash_history | \
                      sort -u | \
                      sed 's/^ssh //' | \
                      sed 's/-. //' | \
                      sed 's/[0-9]* //'))" ssh

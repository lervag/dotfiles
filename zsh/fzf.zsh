fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 \
    | awk '!v[substr($0, 8)]++' \
    | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
      +m +s \
      -n2..,.. \
      --tiebreak=index \
      --inline-info \
      --exact \
      --query=${(qqq)LBUFFER}" \
      $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  zle accept-line
}

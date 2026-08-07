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
      --bind 'ctrl-c:accept' \
      --bind 'ctrl-g:accept' \
      --bind 'ctrl-q:accept' \
      --bind    'esc:accept' \
      --bind 'enter:execute(touch /tmp/ctrlr_mark_1)+accept' \
      --bind 'ctrl-o:execute(touch /tmp/ctrlr_mark_2)+accept' \
      --exact \
      --query=${(qqq)LBUFFER}" \
      $(__fzfcmd)) )
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  if [ -e /tmp/ctrlr_mark_1 ]; then
    zle accept-line
  elif [ -e /tmp/ctrlr_mark_2 ]; then
    zle accept-line-and-down-history
  fi
  rm -f /tmp/ctrlr_mark_{1..2} &>/dev/null
}

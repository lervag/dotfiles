fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
  # zle accept-line-and-down-history
}
zle -N fzf-history-widget-accept
bindkey '^R' fzf-history-widget-accept

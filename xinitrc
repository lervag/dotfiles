#!/bin/sh

# exec startxfce4

# hsetroot -solid "#333333"
# xcompmgr &
# exec openbox-session

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

exec startfluxbox

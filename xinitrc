#!/bin/sh

# exec startxfce4

# hsetroot -solid "#333333"
# xcompmgr &
# exec openbox-session

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Start screensaver after some time
( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )

exec startfluxbox

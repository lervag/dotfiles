#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -I$HOME -merge ~/.Xresources

# Start screensaver after some time
( ( sleep 10 && /usr/bin/xscreensaver -no-splash -display :0.0 ) & )

exec startfluxbox

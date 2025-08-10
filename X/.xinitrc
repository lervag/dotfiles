#!/bin/bash

[[ -f ~/.Xresources ]] && xrdb -I"$HOME" -merge ~/.Xresources

# Start screensaver after some time
( ( sleep 9 \
  && /usr/bin/xscreensaver -display :0.0 &> ~/.cache/xscreensaver.log ) & )

exec startfluxbox

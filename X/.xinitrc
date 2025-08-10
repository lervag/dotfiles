#!/bin/bash

[[ -f ~/.Xresources ]] && xrdb -I"$HOME" -merge ~/.Xresources

# Start screensaver after some time
( ( sleep 9 \
  && /usr/bin/xscreensaver -display :0.0 &> ~/.cache/xscreensaver.log ) & )

# Ensure that the Xorg session has a valid keyboard layout
setxkbmap \
  -model pc105 \
  -layout no \
  -variant nodeadkeys \
  -option ctrl:nocaps \
  -option compose:rctrl

exec startfluxbox

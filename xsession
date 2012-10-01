#!/bin/sh

xsetroot -gray

[ -f /usr/bin/selfspy ] && exec /usr/bin/selfspy
[ -f /usr/bin/conky ]   && exec /usr/bin/conky

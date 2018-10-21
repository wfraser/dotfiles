#!/bin/sh

setxkbmap -option "caps:escape"
exec /usr/bin/herbstluftwm --locked

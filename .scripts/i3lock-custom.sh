#!/bin/sh

set -e

export BACKGROUND="$(cat ~/.config/nitrogen/bg-saved.cfg | grep file | cut -d '=' -f 2-)"

FILENAME="$(basename -- "$BACKGROUND")"
FILENAME="${FILENAME%.*}"

if test ! -f ~/.bgcache/"$FILENAME".png; then
  magick convert "$BACKGROUND" -resize 1920x1080 -gravity center -background black -extent 1920x1080 -quality 90 ~/.bgcache/"$FILENAME".png
fi

i3lock -i ~/.bgcache/"$FILENAME".png

#!/bin/sh

set -e

export BACKGROUND="$(cat ~/.config/nitrogen/bg-saved.cfg | grep file | cut -d '=' -f 2- | head -n 1)"

FILENAME="$(basename -- "$BACKGROUND")"
FILENAME="${FILENAME%.*}"

if test ! -d ~/.bgcache; then
  mkdir ~/.bgcache
fi

function get_date() {
  if $# -ne 1; then
    echo -e '\033[31mget_date: invalid argument exception\033[0m'
    exit 1
  fi

  date -d "$(stat "$BACKGROUND" | grep Modify | cut -d ' ' -f 2-)" +%s
}

if test ! -f ~/.bgcache/"$FILENAME".png || (( "$(get_date "$BACKGROUND")" > "$(get_date "~/.bgcache/$FILENAME")" )); then
  magick convert "$BACKGROUND" -resize 1920x1080 -gravity center -background black -extent 1920x1080 -quality 90 ~/.bgcache/"$FILENAME".png
fi

if test "$(xrandr --query | grep '\sconnected' | wc -l)" -eq 1; then
  i3lock -i ~/.bgcache/"$FILENAME".png
else
  # i3lock-multimonitor -i ~/.bgcache/"$FILENAME".png
  i3lock -ti ~/.bgcache/"$FILENAME".png
fi

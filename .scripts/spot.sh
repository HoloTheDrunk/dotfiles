#!/bin/bash

set -e

SPOTIFY_META="$(playerctl -p spotify metadata)"
PREV_ID=''

test ! -d "$HOME/.bgcache/spotify" && mkdir "$HOME/.bgcache/spotify"

function change_overlay_image() {
  test -z "$1" && exit 1

  local background="$(cat ~/.config/nitrogen/bg-saved.cfg | grep file | cut -d '=' -f 2- | head -n 1)"

  local album="$HOME/.bgcache/spotify/$1"
  magick convert "$album" -resize 200x200 -gravity center -background black -quality 90 "$album"

  local result="$HOME/.bgcache/spotify/spotify_overlay.png"

  magick convert -size 1920x1080 "$background" -page +30+60 "$album" -layers flatten "$result"
  magick composite "$background" "$result" -blend 70x30% "$result"

  local sizes="$(xrandr --query | grep ' connected' | grep -Po '\d+x\d+')"

  local display=0
  while IFS= read -r size; do
    if test "$size" != "1920x1080"; then
      magick convert "$result" -resize "$size" -gravity center -background black -extent "$size" -quality 90 "$result.$display"
      nitrogen --set-zoom -head="$display" "$result.$display"
      rm "$result.$display"
    else
      nitrogen --set-zoom --head="$display" "$result"
    fi

    display=$((display + 1))
  done <<< "$sizes"
}

function get_field() {
  [ $# -ne 1 ] && exit 1
  FIELD="$(grep "$1" <<< "$SPOTIFY_META" | tr -s ' ' | cut -d ' ' -f 3-)"
}

function get_status() {
  SPOTIFY_META="$(playerctl -p spotify metadata)"
}

function update_image() {
  get_field artUrl; local url="$FIELD"
  get_field title ; local title="$(tr -d ' ' <<< "$FIELD")"

  wget -c "$url" -O "$HOME/.bgcache/spotify/$title.png"

  change_overlay_image "$title.png"
}

while true; do
  if test "$SPOTIFY_STATUS" != "No players found"; then
    CURRENT_ID="$(get_field trackid; echo "$FIELD")"
    if test "$CURRENT_ID" != "$PREV_ID"; then
      PREV_ID="$CURRENT_ID"
      update_image
    else
      get_status
    fi
  else
    nitrogen --set-zoom "$HOME/Images/backgrounds/bg.png"
  fi

  sleep 1
done

#!/bin/bash

set -e

if [ $# -ne 1 ] || [ "$1" = "--help" ]; then
  echo "Usage: bright [0..1]"
  exit 1
fi

case "$1" in
  ''|*[!0-9.-]*) echo "Argument must be a number." && exit 1;;
  *);;
esac

MONITORS=$(xrandr --listmonitors | tail +2)

while IFS= read -r line; do
  MONITOR="$(echo "$line" | sed -E 's/ /\n/g' | tail -n 1)"

  echo "Adjusting brightness for $MONITOR."

  xrandr --output "$MONITOR" --brightness "$1"
done <<< "$MONITORS"

#!/bin/bash

number=$1
move=$2

desktops=$(bspc query -m focused -D)

selected_desktop=$(echo "$desktops" | awk "NR == $number {print}")

if ! test -z "$selected_desktop"; then

  if [ "$move" = "move" ]; then
    bspc node -d $selected_desktop --follow
  else
    bspc desktop -f "$selected_desktop"
  fi

else
  exit 1
fi

#!/bin/bash

action=$1

if [ "$action" = "prev" ]; then
  desktops=$(bspc query -m focused -D | tac)
else
  desktops=$(bspc query -m focused -D)
fi

current_desktop=$(bspc query -d focused -D)
next_desktops=$(echo "$desktops" | awk "/$current_desktop/ {found=1; next} found")

while IFS= read -r next_desktop; do
    
    window_count=$(bspc query -N -d "$next_desktop" | wc -l)

    if [ "$window_count" -gt 0 ]; then
        bspc desktop -f "$next_desktop"
        exit 0
    fi

done <<< "$next_desktops"

current_dir=$(dirname "$0")
"$current_dir/polybar_ping_small.sh"

exit 1

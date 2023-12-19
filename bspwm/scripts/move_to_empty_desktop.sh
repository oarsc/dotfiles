#!/bin/bash

action=$1

if [ "$action" = "monitor" ]; then

    if [[ $(bspc query -M | wc -l) -lt 2 ]]; then
        # only 1 monitor available
        monitor=$(bspc query -M -m)
        action=""
    else
        monitor=$(bspc query -M -m next)
    fi
else
    monitor=$(bspc query -M -m)
fi

[ "$monitor" ] || exit 1

desktop=$(bspc query -D -m $monitor -d .\!occupied | head -n 1)
[ "$desktop" ] || exit 1

bspc node -d $desktop
bspc desktop $desktop -l tiled
if [ "$action" = "monitor" ]; then
    bspc desktop -a $desktop
else
    bspc desktop -f $desktop
fi

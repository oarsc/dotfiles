#!/bin/bash

if [ "$1" = "monitor" ]; then

    if [[ $(bspc query -M | wc -l) -lt 2 ]]; then
        echo "This action requires multiple monitors"
        exit 1
    fi

    monitor=$(bspc query -M -m next)
#    if [ -z $monitor ]; then
#        monitor=$(bspc query -M -m .\!focused | head -n 1)
#    fi
else
    monitor=$(bspc query -M -m)
fi

[ "$monitor" ] || exit 1

desktop=$(bspc query -D -m $monitor -d .\!occupied | head -n 1)
[ "$desktop" ] || exit 1

bspc node -d $desktop
bspc desktop $desktop -l tiled
bspc desktop -f $desktop

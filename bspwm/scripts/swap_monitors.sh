#!/bin/bash

if [[ $(bspc query -M | wc -l) -lt 2 ]]; then
    notify-send "This action requires multiple monitors"
    echo "This action requires multiple monitors"
    exit 1
fi

source "$(dirname "$(realpath "$0")")/xtapper.sh"

function execution {
    id_1=$(bspc query -D -d '^1:focused')
    id_2=$(bspc query -D -d '^2:focused')

    name_1=$(bspc query -D -d '^1:focused' --names)
    name_2=$(bspc query -D -d '^2:focused' --names)

    bspc desktop $id_2 -n "$name_2" -s $id_1
    bspc desktop $id_2 -n "$name_1"
    bspc desktop $id_1 -n "$name_2"

    # Set "last" desktop as the other monitor
    focus=$(bspc query -D -d)

    if [ "$focus" = "$id_1" ]; then
        bspc desktop -f $id_2
    else
        bspc desktop -f $id_1
    fi
    #bspc desktop -f $focus
}

function next {
    bspc monitor -f next
}

xTapper "$0 $@" execution 2 next
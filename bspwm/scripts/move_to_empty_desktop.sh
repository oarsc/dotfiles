#!/bin/bash

source "$(dirname "$(realpath "$0")")/xtapper.sh"

action=$1

function execution {
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

    [ "$action" = "monitor" ] && bspc desktop -a $desktop

    echo "$monitor $desktop"
}

function next {
    if [ "$action" = "monitor" ]; then
        # If the monitor where we wanted to move is the one focused now, then reexecute the code.
        # Switch to the other monitor otherwise.
        # TODO: Fix this logic if more than 2 monitors...
        bspc query -M -m $1.focused && process || bspc monitor -f $1
    else
        bspc desktop -f $2
    fi
}

xTapper "$0 $@" execution 2 next

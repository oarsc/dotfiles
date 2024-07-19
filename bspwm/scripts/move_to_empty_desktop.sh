#!/bin/bash

action=$1

pids=$(pgrep -f "$(basename "$0")")
if [ "$(echo "$pids" | wc -w)" -gt 1 ]; then
    kill $pids
fi

process() {
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

        sigtermFunct() {
            # If the monitor where we wanted to move is the one focused now, then reexecute the code.
            # Switch to the other monitor otherwise.
            # TODO: Fix this logic if more than 2 monitors...
            bspc query -M -m $monitor.focused && process || bspc monitor -f $monitor
        }
        trap 'sigtermFunct' SIGTERM
    else
        trap "bspc desktop -f $desktop" SIGTERM
    fi

    sleep 2 & wait
}

process
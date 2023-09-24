#!/bin/bash

if [ "$1" = "follow" ]; then
    monitor="$(bspc query -M -m last)"
    if [ -z $monitor ]; then
        monitor="$(bspc query -M -m .\!focused | head -n 1)"
    fi

    bspc node -m $monitor
    bspc monitor -f $monitor
else
    bspc node -m last
fi

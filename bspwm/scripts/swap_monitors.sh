#!/bin/sh

id_1="$(bspc query -D -d '^1:focused')" || exit 1
id_2="$(bspc query -D -d '^2:focused')" || exit 1

name_1="$(bspc query -D -d '^1:focused' --names)" || exit 1
name_2="$(bspc query -D -d '^2:focused' --names)" || exit 1

bspc desktop $id_2 -n "$name_2" -s $id_1
bspc desktop $id_2 -n "$name_1"
bspc desktop $id_1 -n "$name_2"

# Set "last" desktop as the other monitor
focus="$(bspc query -D -d)" || exit 1

if [ $focus = $id_1 ]; then
    bspc desktop -f $id_2
else
    bspc desktop -f $id_1
fi
bspc desktop -f $focus

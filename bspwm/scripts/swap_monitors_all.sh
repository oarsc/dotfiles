#!/bin/bash

if [[ $(bspc query -M | wc -l) -lt 2 ]]; then
    echo "This action requires multiple monitors"
    exit 1
fi

num_desktops=$(bspc query -D -m focused | wc -l)

desktops_i=$(bspc query -D -m focused | tr '\n' ',')
desktops_f=$(bspc query -D -m next | tr '\n' ',')

desktops_names_i=$(bspc query -D -m focused --names | tr '\n' ',')
desktops_names_f=$(bspc query -D -m next --names | tr '\n' ',')

focus_i=$(bspc query -D -d focused:focused)
focus_f=$(bspc query -D -d next:focused)

for (( i=1; i<=$num_desktops; i++ )); do
    di=$(echo $desktops_i | cut -d',' -f$i)
    df=$(echo $desktops_f | cut -d',' -f$i)

    ni=$(echo $desktops_names_i | cut -d',' -f$i)
    nf=$(echo $desktops_names_f | cut -d',' -f$i)

    bspc desktop $df -s $di
    #bspc desktop $df -n "$nf" -s $di
    #bspc desktop $df -n "$ni"
    #bspc desktop $di -n "$nf"
done

bspc desktop -f $focus_i
bspc desktop -f $focus_f

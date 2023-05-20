#!/bin/bash

if [ "$#" -ne 1 ]; then
    >&2 echo "Missing monitor index parameter. Use 0 to select all monitors"
    exit 1
fi

function array() {
    local -n output=$1
    value=$(tr '\n' ' ' <<< $2)
    IFS=' ' read -r -a output <<< "$value"
}

SELECTED_MONITOR=$1

array MONITORS "$(xrandr --query | grep " connected" | cut -d" " -f1)"
LENGTH=${#MONITORS[@]}
POSITIONS=( 0x0 2560x180 )

if [ $LENGTH -lt $SELECTED_MONITOR ]; then
    >&2 echo "Monitor index out of range ($LENGTH)";
    exit 1
fi

if type "xrandr"; then
    if [ $SELECTED_MONITOR -eq 0 ]; then

        array RESOLUTIONS "$(xrandr --query | grep " connected" -A 1 | grep -v " connected" | grep -v '\-\-' | awk '{print $1}')"

        for (( i = 0 ; i < ${#MONITORS[@]} ; i++ )); do
            xrandr --output ${MONITORS[$i]} --mode ${RESOLUTIONS[$i]} --pos ${POSITIONS[$i]} --rotate normal
        done

    else
        for i in $(seq 1 $LENGTH); do
            if [ $i -ne $SELECTED_MONITOR ]; then
                bspc monitor ${MONITORS[$i-1]} -r
                xrandr --output ${MONITORS[$i-1]} --off
            fi
        done

        RESOLUTION=$(xrandr --query | grep " connected" -A 1 | grep -v " connected" | grep -v '\-\-' | awk '{print $1}' | sed -n "$SELECTED_MONITOR p")
        MONITOR=${MONITORS[$SELECTED_MONITOR-1]}

        xrandr --output $MONITOR --mode $RESOLUTION --pos 0x0 --rotate normal
    fi

    ~/.config/bspwm/bspwmrc

else
    >&2 echo "xrandr not found"
    exit 1
fi


# ## screen1
# bspc monitor HDMI-0 -r
# xrandr --output HDMI-0 --off --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal
# ~/.config/bspwm/bspwmrc
# 
# ## screen2
# xrandr --output HDMI-0 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --mode 1920x1080 --pos 2560x180 --rotate normal
# ~/.config/bspwm/bspwmrc
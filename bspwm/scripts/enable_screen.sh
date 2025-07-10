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

INDEX=$(($1-1))

array MONITORS "$(xrandr --query | grep " connected" | cut -d" " -f1)"
array RESOLUTIONS "$(xrandr --query | grep " connected" -A 1 | grep -v " connected" | grep -v '\-\-' | awk '{print $1}')"

POSITIONS=( "0x0 --rate 144" 2560x180 )

LENGTH=${#MONITORS[@]}

if [ $LENGTH -lt $((INDEX + 1)) ]; then
    >&2 echo "Monitor index out of range ($LENGTH)";
    exit 1
fi

if type "xrandr"; then
    if [ $INDEX -eq -1 ]; then

        for (( i = 0 ; i < ${#MONITORS[@]} ; i++ )); do
            xrandr --output ${MONITORS[$i]} --mode ${RESOLUTIONS[$i]} --pos ${POSITIONS[$i]} --rotate normal
        done

    else

        # We need both monitors and bspwm on them to move the elements to the current monitor
        for (( i = 0 ; i < ${#MONITORS[@]} ; i++ )); do
            xrandr --output ${MONITORS[$i]} --mode ${RESOLUTIONS[$i]} --pos ${POSITIONS[$i]} --rotate normal
        done

        $HOME/.config/bspwm/startup/bspwm-screen-startup

        monitorDesktops=($(bspc wm -d | jq -r '.monitors[].desktops | map(.id) | tostring | "" + . + ""'))
        selectedMonitorDesktops=($(echo ${monitorDesktops[$INDEX]} | jq '.[]'))
        
        for i in $(seq 0 $(($LENGTH - 1))); do
            if [ $i -ne $INDEX ]; then

                desktops=($(echo ${monitorDesktops[$i]} | jq '.[]'))

                for j in $(seq 0 $((${#selectedMonitorDesktops[@]} - 1))); do
                    nodes=$(bspc query -N -d ${desktops[$j]})
                    for node in $nodes; do
                        bspc node $node -d ${selectedMonitorDesktops[$j]}
                    done
                done

                bspc monitor ${MONITORS[$i]} -r
                xrandr --output ${MONITORS[$i]} --off
            fi
        done

        RESOLUTION=$(xrandr --query | grep " connected" -A 1 | grep -v " connected" | grep -v '\-\-' | awk '{print $1}' | sed -n "$1 p")
        MONITOR=${MONITORS[$INDEX]}

        xrandr --output $MONITOR --mode $RESOLUTION --pos 0x0 --rotate normal
    fi

    $HOME/.config/bspwm/startup/polybar-startup &
    $HOME/.config/bspwm/startup/bspwm-screen-startup &

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
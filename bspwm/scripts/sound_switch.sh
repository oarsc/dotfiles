#!/bin/bash


CURRENT=$(pactl info | grep "Default Sink: " | sed "s/Default Sink\: //")

found=false
for sink in $(pactl list short sinks); do
    if  [[ $sink == alsa_output* ]]; then
        if [ -z "$first_sink" ]; then
            first_sink=$sink
        fi

        if  [[ $sink == $CURRENT ]]; then
            found=true
        else
            if [ $found == true ]; then
                pactl set-default-sink "$sink"
                notify-send $(echo $sink | sed "s/alsa_output\.//")
                exit 0
            fi
        fi
    fi
done

pactl set-default-sink "$first_sink"
notify-send $(echo $first_sink | sed "s/alsa_output\.//")

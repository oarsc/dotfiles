#!/bin/bash

CURRENT=$(pactl info | grep "Default Sink: " | sed "s/Default Sink\: //")

found=false
for sink in $(pactl list short sinks); do
    if  [[ $sink == alsa_output* ]]; then
        if [ -z "$sink_to_use" ]; then
            sink_to_use=$sink
        fi

        if  [[ $sink == $CURRENT ]]; then
            found=true
        else
            if [[ $found == true && $sink != *hdmi* ]]; then
                sink_to_use="$sink"
                break
            fi
        fi
    fi
done

pactl set-default-sink "$sink_to_use"
for stream in $(pactl list short sink-inputs | cut -f1); do
	pactl move-sink-input "$stream" "$sink_to_use"
done

sink_name="$(pactl list sinks | grep -A 20 "$sink_to_use" | grep "alsa.card_name" | cut -d '"' -f 2)"
notify-send "Audio Device: $sink_name"

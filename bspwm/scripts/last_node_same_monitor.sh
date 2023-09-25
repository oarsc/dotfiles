#!/bin/bash

currentMonitor=$(bspc query -M -m)
currentNode=$(bspc query -N -n)

while IFS= read -r nodeId; do
    nodeMonitor=$(bspc query -M -n $nodeId)
    nodeIdHex=$(bspc query -N -n $nodeId)

    if [ "$nodeMonitor" = "$currentMonitor" ] && [ "$currentNode" != "$nodeIdHex" ]; then
        bspc node -f $nodeIdHex
        exit 0
    fi

done <<< $(bspc wm -d | sed -r 's/.*stackingList":\[(.*)\].*/\1/' | sed 's/,/\n/g' | tac)

exit 1

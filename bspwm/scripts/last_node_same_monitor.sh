#!/bin/bash

currentMonitorHex=$(bspc query -M -m)
currentNodeHex=$(bspc query -N -n)

currentMonitor=$(echo $currentMonitorHex | sed 's/0x//; s/^/ibase=16;/' | bc)
currentNode=$(echo $currentNodeHex | sed 's/0x//; s/^/ibase=16;/' | bc)

while IFS= read -r nodeId; do
    if [ "$currentNode" != "$nodeId" ]; then
        bspc node -f $nodeId
        exit 0
    fi

done <<< $(bspc wm -d | jq ".focusHistory | map(select(.nodeId != 0 and .monitorId == $currentMonitor)) | reverse | .[].nodeId")


while IFS= read -r nodeId; do
    nodeMonitor=$(bspc query -M -n $nodeId)
    nodeIdHex=$(bspc query -N -n $nodeId)

    if [ "$nodeMonitor" = "$currentMonitorHex" ] && [ "$currentNodeHex" != "$nodeIdHex" ]; then
        bspc node -f $nodeIdHex
        exit 0
    fi

done <<< $(bspc wm -d | sed -r 's/.*stackingList":\[(.*)\].*/\1/' | sed 's/,/\n/g' | tac)

exit 1

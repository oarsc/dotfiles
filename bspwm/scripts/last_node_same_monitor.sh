#!/bin/bash

currentMonitorHex=$(bspc query -M -m)
currentNodeHex=$(bspc query -N -n)
currentDesktopHex=$(bspc query -D -d)

currentMonitor=$(echo $currentMonitorHex | sed 's/0x//; s/^/ibase=16;/' | bc)
currentNode=$(echo $currentNodeHex | sed 's/0x//; s/^/ibase=16;/' | bc)

bspcwmd=$(bspc wm -d)

function swapNode {
    bspc node -f $1

    if [ "$(bspc query -D -n $1)" == "$currentDesktopHex" ]; then
        current_dir=$(dirname "$0")
        "$current_dir/polybar_ping_small.sh"
    fi
}

while IFS= read -r nodeId; do

    if [ "$currentNode" != "$nodeId" ]; then
        swapNode $nodeId
        exit 0
    fi

done <<< $(echo $bspcwmd | jq ".focusHistory | map(select(.nodeId != 0 and .monitorId == $currentMonitor)) | reverse | .[].nodeId")


while IFS= read -r nodeId; do
    nodeMonitorHex=$(bspc query -M -n $nodeId)
    nodeIdHex=$(bspc query -N -n $nodeId)

    if [ "$nodeMonitorHex" = "$currentMonitorHex" ] && [ "$currentNodeHex" != "$nodeIdHex" ]; then
        swapNode $nodeIdHex
        exit 0
    fi

done <<< $(echo $bspcwmd | jq ".stackingList | reverse | .[]")

current_dir=$(dirname "$0")
"$current_dir/polybar_ping_small.sh"

exit 1

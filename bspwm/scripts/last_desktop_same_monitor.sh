#!/bin/bash

currentMonitorHex=$(bspc query -M -m)
currentDesktopHex=$(bspc query -D -d)

currentMonitor=$(echo $currentMonitorHex | sed 's/0x//; s/^/ibase=16;/' | bc)

bspcwmd=$(bspc wm -d)

while IFS= read -r nodeId; do
    nodeDesktop=$(bspc query -D -n $nodeId)

    if [ "$currentDesktopHex" != "$nodeDesktop" ]; then
        bspc desktop -f $nodeDesktop
        exit 0
    fi

done <<< $(echo $bspcwmd | jq ".focusHistory | map(select(.nodeId != 0 and .monitorId == $currentMonitor)) | reverse | .[].nodeId")


while IFS= read -r nodeId; do
    nodeMonitor=$(bspc query -M -n $nodeId)
    nodeDesktop=$(bspc query -D -n $nodeId)

    if [ "$nodeMonitor" = "$currentMonitorHex" ] && [ "$currentDesktopHex" != "$nodeDesktop" ]; then
        bspc desktop -f $nodeDesktop
        exit 0
    fi

done <<< $(echo $bspcwmd | jq ".stackingList | reverse | .[]")

bspc desktop -f last.local
exit $?

#!/bin/bash

currentMonitor=$(bspc query -M -m)
currentDesktop=$(bspc query -D -d)

while IFS= read -r nodeId; do
    nodeMonitor=$(bspc query -M -n $nodeId)
    nodeDesktop=$(bspc query -D -n $nodeId)

    if [ "$nodeMonitor" = "$currentMonitor" ] && [ "$currentDesktop" != "$nodeDesktop" ]; then
        bspc desktop -f $nodeDesktop
        exit 0
    fi

done <<< $(bspc wm -d | sed -r 's/.*stackingList":\[(.*)\].*/\1/' | sed 's/,/\n/g' | tac)

bspc desktop -f last.local
exit $?

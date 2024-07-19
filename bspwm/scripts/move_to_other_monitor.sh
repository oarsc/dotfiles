#!/bin/bash

pids=$(pgrep -f "$(basename "$0")")
if [ "$(echo "$pids" | wc -w)" -gt 1 ]; then
    kill $pids
fi

process() {
    monitorId=$(bspc query -M -m focused)
    nodeId=$(bspc query -N -n focused)
    [ "$nodeId" ] || exit 1

    bspc node -m last || bspc node -m next

    sigtermFunct() {
        # If the monitor where we started from is still focused, then follow the node.
        # Reexecute otherwise
        bspc query -M -m $monitorId.focused && bspc node -f $nodeId || process
    }
    trap 'sigtermFunct' SIGTERM

    sleep 2 & wait
}

process
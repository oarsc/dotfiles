#!/bin/bash

pids=$(pgrep -f "$(basename "$0")")
if [ "$(echo "$pids" | wc -w)" -gt 1 ]; then
    kill $pids
fi

nodeId=$(bspc query -N -n focused)
[ "$nodeId" ] || exit 1

bspc node -m last || bspc node -m next
trap "bspc node -f $nodeId" SIGTERM

sleep 2 & wait

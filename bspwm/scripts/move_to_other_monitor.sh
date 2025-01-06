#!/bin/bash

source "$(dirname "$(realpath "$0")")/xtapper.sh"

function execution {
    monitorId=$(bspc query -M -m focused)
    nodeId=$(bspc query -N -n focused)
    [ "$nodeId" ] || exit 1

    bspc node -m last || bspc node -m next

    echo "$monitorId $nodeId"
}

function next {
    bspc query -M -m $1.focused && bspc node -f $2 || process
}

xTapper "$0 $@" execution 2 next

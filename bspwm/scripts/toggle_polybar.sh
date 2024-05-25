#!/bin/bash

POLYBAR_SIZE=36

current_size=$(bspc wm -d | jq ".monitors[0]".padding.top)
monitors=$(bspc query --monitors)

if test "$current_size" -gt 0; then
  polybar-msg cmd hide

  while IFS= read -r nodeId; do
    bspc config -m $nodeId top_padding 0
  done <<< $monitors

else
  polybar-msg cmd show

  while IFS= read -r nodeId; do
    bspc config -m focused top_padding $POLYBAR_SIZE
  done <<< $monitors
fi

#!/bin/bash

POLYBAR_SIZE=36

current_size=$(bspc wm -d | jq ".monitors[0]".padding.top)
monitors=$(bspc query --monitors)

if test "$current_size" -gt 0; then
  pids=$(pgrep -f "polybar.*main")
  for pid in $pids; do
    polybar-msg -p $pid cmd hide
  done

  while IFS= read -r nodeId; do
    bspc config -m $nodeId top_padding 0
  done <<< $monitors

  touch $HOME/.polybar-hidden

else
  pids=$(pgrep -f "polybar.*main")
  for pid in $pids; do
    polybar-msg -p $pid cmd show
  done

  while IFS= read -r nodeId; do
    bspc config -m focused top_padding $POLYBAR_SIZE
  done <<< $monitors

  rm $HOME/.polybar-hidden
fi

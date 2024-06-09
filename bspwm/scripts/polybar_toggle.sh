#!/bin/bash

POLYBAR_SIZE=36
SMALL_POLYBAR_SIZE=18

monitors=$(bspc query --monitors)

pidsMain=$(pgrep -f "polybar.*main")
pidsSmall=$(pgrep -f "polybar.*small")

if [ -e "$HOME/.polybar-hidden" ]; then
  for pid in $pidsMain; do
    polybar-msg -p $pid cmd show
  done

  for pid in $pidsSmall; do
    polybar-msg -p $pid cmd hide
  done

  while IFS= read -r monitorId; do
    bspc config -m $monitorId top_padding $POLYBAR_SIZE
  done <<< $monitors

  rm "$HOME/.polybar-hidden"

else
  for pid in $pidsMain; do
    polybar-msg -p $pid cmd hide
  done

  for pid in $pidsSmall; do
    polybar-msg -p $pid cmd show
  done

  while IFS= read -r monitorId; do
    bspc config -m $monitorId top_padding $SMALL_POLYBAR_SIZE
  done <<< $monitors

  touch "$HOME/.polybar-hidden"
fi

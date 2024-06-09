#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  bspc query -M -m primary.focused || bspc query -M | wc -l | grep -q '^1$'
  alt=$?
else
  alt=$1
fi

toggle() {
  if [ "$alt" -eq 0 ]; then
    polybar-msg action multiple-monocle module_$1
  else
    polybar-msg action multiple-monocle-alt module_$1
  fi
}

layout=$(bspc query -T -d focused | jq -r '.userLayout')

if [ "$layout" = "monocle" ]; then
  toggle show
else
  toggle hide
fi
#!/bin/bash

if [ ! -e "$HOME/.polybar-hidden" ]; then
  exit 0
fi

if [ $# -eq 0 ]; then
  num_monitors=$(bspc query -M | wc -l)
  if [ $num_monitors -gt 1 ]; then
    bspc query -M -m primary.focused
    if [ $? -eq 0 ]; then
      "$0" main
    else
      "$0" alt
    fi
  else
    "$0" main
  fi
  exit 0
fi

pids=$(pgrep -f "$(basename "$0") $1")
for pid in $pids; do
  if [ "$pid" != "$$" ]; then
    kill -9 "$pid"
  fi
done

if [ "$1" = "alt" ]; then
  pid=$(pgrep -f "polybar.*small-alt")
else
  pid=$(pgrep -f "polybar.*small ")
fi


polybar-msg -p $pid cmd show

(sleep 1.5; polybar-msg -p $pid cmd hide) &
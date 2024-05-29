#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
if type "xrandr"; then

  MONITORS=$(xrandr --query | grep " connected" | grep "+" | cut -d" " -f1 | tr '\n' ' ');
  IFS=' ' read -r -a ARR_MONITORS <<< "$MONITORS"

  MONITOR=${ARR_MONITORS[0]} polybar -q main -c "$DIR"/config.ini &

  MONITOR=${ARR_MONITORS[0]} polybar -q small -c "$DIR/config.ini" &
    (xdo id -m -N Polybar && polybar-msg -p $! cmd hide) &

  if [ ${ARR_MONITORS[1]} ]; then
    MONITOR=${ARR_MONITORS[1]} polybar -q main-alt -c "$DIR"/config.ini &

    MONITOR=${ARR_MONITORS[1]} polybar -q small-alt -c "$DIR/config.ini" &
      (xdo id -m -N Polybar && polybar-msg -p $! cmd hide) &
  fi

else
  polybar -q main -c "$DIR"/config.ini &
fi
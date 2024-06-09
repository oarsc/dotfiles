#!/bin/bash

# input args:
#  NUM_MONITORS PID_POLYBAR PID_SMALL_POLYBAR [PID_ALT_POLYBAR PID_SMALL_ALT_POLYBAR]

BASEDIR=$(dirname "$0")

if [ -e "$HOME/.polybar-hidden" ]; then
  rm "$HOME/.polybar-hidden"
  $BASEDIR//polybar-toggle.sh
else
  polybar-msg -p $3 cmd hide
fi
$BASEDIR/check-monocles.sh 0

if [ "$1" -gt 1 ]; then
  if [ ! -e "$HOME/.polybar-hidden" ]; then
    polybar-msg -p $5 cmd hide
  fi
  
  polybar-msg action multiple-monocle-alt module_hide
fi

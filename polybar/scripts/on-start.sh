#!/bin/bash

# input args:
#  NUM_MONITORS PID_POLYBAR [PID_ALT_POLYBAR]

BASEDIR=$(dirname "$0")

if [ -e "$HOME/.polybar-hidden" ]; then
  rm "$HOME/.polybar-hidden"
  
  $BASEDIR//polybar-toggle.sh
fi

polybar-msg action "#multiple-monocle.module_hide"
polybar-msg action "#multiple-monocle-alt.module_hide"

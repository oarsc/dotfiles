#!/bin/bash

#  █▀ ▀█▀ ▄▀█ █▀█ ▀█▀ █ █ █▀█
#  ▄█  █  █▀█ █▀▄  █  █▄█ █▀▀
# ----------------------------

pgrep -x ualth > /dev/null || ualth &
pgrep -x dropbox > /dev/null || dropbox start &

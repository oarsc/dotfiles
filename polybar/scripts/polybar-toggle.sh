#!/bin/bash

#modules="stock-live memory cpu-temp"
modules="stock-live"

if [ -e "$HOME/.polybar-hidden" ]; then
  rm "$HOME/.polybar-hidden"
  for module in $modules; do
    polybar-msg action "#$module.module_show"
  done
  
else
  touch "$HOME/.polybar-hidden"
  for module in $modules; do
    polybar-msg action "#$module.module_hide"
  done
fi

#!/usr/bin/env bash

module_names="public-network"

for module in $module_names; do
  polybar-msg action $module module_toggle
done

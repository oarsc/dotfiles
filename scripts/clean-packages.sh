#!/bin/bash

# Remove keybinding default packages
apt autoremove regolith-i3-gnome regolith-i3-next-workspace regolith-i3-workspace-config regolith-i3-base-launchers

# Removing keybinding config files if they still exists
rm /usr/share/regolith/i3/config.d/15_base_launchers \
  /usr/share/regolith/i3/config.d/40_next-workspace \
  /usr/share/regolith/i3/config.d/40_workspace-config \
  /usr/share/regolith/i3/config.d/60_config_keybindings
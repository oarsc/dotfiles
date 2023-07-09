#!/usr/bin/env bash

dir="~/.config/polybar/scripts/rofi"

# Options
both=" Extend screens"
main=" First screen only"
secondary=" Second screen only"

# Variable passed to rofi
options="$both\n$main\n$secondary"

chosen="$(echo -e "$options" | rofi -no-config -theme $dir/screensmenu.rasi -monitor -1 -p "Project" -dmenu -selected-row 0)"
case $chosen in
    $both)
		~/.config/bspwm/scripts/enable_screen.sh 0
        ;;
    $main)
		~/.config/bspwm/scripts/enable_screen.sh 1
        ;;
    $secondary)
		~/.config/bspwm/scripts/enable_screen.sh 2
        ;;
esac

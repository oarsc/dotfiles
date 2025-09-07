#!/usr/bin/env bash

dir="~/.config/polybar/scripts/rofi"

# Options
both=" Extend screens"
main=" First screen only"
secondary=" Second screen only"
both60=" Extend screens (60Hz)"
main60=" First screen only (60Hz)"

# Variable passed to rofi
options="$both\n$main\n$secondary\n$both60\n$main60"

chosen="$(echo -e "$options" | rofi -no-config -theme $dir/screensmenu.rasi -monitor -1 -p "Project" -dmenu -selected-row 0)"
case $chosen in
    $both)
		~/.config/bspwm/scripts/enable_screen.sh 0
        ;;
    $both60)
		~/.config/bspwm/scripts/enable_screen.sh 0 1
        ;;
    $main)
		~/.config/bspwm/scripts/enable_screen.sh 1
        ;;
    $main60)
		~/.config/bspwm/scripts/enable_screen.sh 1 1
        ;;
    $secondary)
		~/.config/bspwm/scripts/enable_screen.sh 2
        ;;
esac

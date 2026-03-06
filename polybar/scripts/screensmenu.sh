#!/usr/bin/env bash

dir="~/.config/polybar/scripts/rofi"

# Options
both=" Extend screens"
main=" First screen only"
secondary=" Second screen only"
redFilter="Add Red filter"
removeFilter="Remove Red filter"
both60=" Extend screens (60Hz)"
main60=" First screen only (60Hz)"

# Variable passed to rofi
options="$both\n$main\n$secondary\n$redFilter\n$removeFilter"

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
    $redFilter)
		nvidia-settings -a Brightness=-0.1 -a DigitalVibrance=-600 -a RedGamma=2 -a GreenGamma=0.7 -a BlueGamma=0.7
        ;;
    $removeFilter)
		nvidia-settings -a Brightness=0 -a DigitalVibrance=0 -a RedGamma=1 -a GreenGamma=1 -a BlueGamma=1
        ;;
esac

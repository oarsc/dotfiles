#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="~/.config/polybar/scripts/rofi"
uptime=$(uptime -p | sed -e 's/up //g')

rofi_command="rofi -no-config -theme $dir/powermenu.rasi -monitor -1"

# Options
lock=" Lock"
reloadFull=" Reload BSPWM"
reloadPolybar=" Reload Polybar"
reloadPicom=" Reload Picom"
reloadDesktop=" Reload Desktop"
suspend="󰤄 Sleep"
logout=" Logout"
reboot=" Restart"
shutdown=" Shutdown"
color=" Color change"

# Confirmation
confirm_exit() {
	rofi -dmenu\
        -no-config\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure? > "\
		-theme $dir/confirm.rasi
}

# Variable passed to rofi
options="$lock\n$logout\n$suspend\n$shutdown\n$reboot\n$color\n$reloadFull\n$reloadPolybar\n$reloadPicom\n$reloadDesktop"

chosen="$(echo -e "$options" | $rofi_command -p "Uptime: $uptime" -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == y* || $ans == Y* ]]; then
			systemctl poweroff
		else
			exit 0
		fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == y* || $ans == Y* ]]; then
			systemctl reboot
		else
			exit 0
		fi
        ;;
    $lock)
		if [[ -f /usr/bin/xsecurelock ]]; then
			~/.config/bspwm/scripts/lock.sh
		elif [[ -f /usr/bin/betterlockscreen ]]; then
			betterlockscreen -l
		fi
        ;;
    $color)
		$HOME/.config/polybar/scripts/color-switch.sh
        ;;
    $reloadFull)
		$HOME/.config/bspwm/bspwmrc
        ;;
    $reloadPolybar)
		$HOME/.config/bspwm/startup/polybar-startup
        ;;
    $reloadPicom)
		$HOME/.config/bspwm/startup/picom-startup
        ;;
    $reloadDesktop)
		$HOME/.config/bspwm/startup/desktop-startup
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == y* || $ans == Y* ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		else
			exit 0
		fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == y* || $ans == Y* ]]; then
			if [[ "$DESKTOP_SESSION" == "Openbox" ]]; then
				openbox --exit
			elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			fi
		else
			exit 0
		fi
        ;;
esac

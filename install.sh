#!/bin/bash

BASEDIR=$(dirname $(readlink -e $0))
CONFIGDIR="$HOME/.config"

sudo pacman -s vi vim docker distrobox waybar network-manager-applet

sudo usermod -aG docker $USER
sudo systemctl enable docker.service
sudo systemctl start docker.service

rm "$CONFIGDIR/hyprland.conf"

ln -s "$BASEDIR/hyprland.conf" "$CONFIGDIR/hyprland.conf"

exit

sudo apt install -y bspwm zsh sxhkd feh kitty dmenu polybar picom rofi xsecurelock scrot dunst jq keychain lm-sensors curl zsh pulseaudio pulseaudio-utils numlockx

ln -s "$BASEDIR/kitty"                "$CONFIGDIR/kitty"
ln -s "$BASEDIR/picom"                "$CONFIGDIR/picom"
ln -s "$BASEDIR/gtk-3.0/settings.ini" "$CONFIGDIR/gtk-4.0/settings.ini"
ln -s "$BASEDIR/zsh"                  "$CONFIGDIR/zsh"
ln -s "$BASEDIR/dunst"                "$CONFIGDIR/dunst"
ln -s "$BASEDIR/.zshrc"               "$HOME/.zshrc"
ln -s "$BASEDIR/.xprofile"            "$HOME/.xprofile"


# Install fonts
mkdir -p "$HOME/.local/share/fonts"
cp -rf $BASEDIR/fonts/* "$HOME/.local/share/fonts"

# Install cursor
sudo apt install breeze-cursor-theme

# zsh Plugins
git clone https://github.com/rupa/z "$BASEDIR/zsh/plugins/z"

# Set default terminal
gsettings set org.gnome.desktop.default-applications.terminal exec 'kitty'

# Oh my ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Nvim
sudo apt install -y xclip neovim

git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git

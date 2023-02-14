#!/bin/bash

BASEDIR=$(dirname "$0")

sudo apt install -y bspwm sxhkd feh kitty dmenu polybar picom rofi apcalc

mkdir -p "$HOME/.config/gtk-3.0"
rm -fr "$HOME/.config/bspwm" "$HOME/.config/sxhkd" "$HOME/.config/polybar" \
       "$HOME/.config/kitty" "$HOME/.config/picom" "$HOME/.config/gtk-3.0/settings.ini" \
       "$HOME/.xprofile"

ln -s "$BASEDIR/bspwm"                "$HOME/.config/bspwm"
ln -s "$BASEDIR/sxhkd"                "$HOME/.config/sxhkd"
ln -s "$BASEDIR/polybar"              "$HOME/.config/polybar"
ln -s "$BASEDIR/kitty"                "$HOME/.config/kitty"
ln -s "$BASEDIR/picom"                "$HOME/.config/picom"
ln -s "$BASEDIR/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
ln -s "$BASEDIR/.xprofile"            "$HOME/.xprofile"


# Install networkmanager-dmenu
sudo apt install -y libnm-dev
mkdir "$HOME/.local/bin"
git clone https://github.com/firecat53/networkmanager-dmenu.git --depth 1
cd networkmanager-dmenu
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"
cp networkmanager_dmenu "$HOME/.local/bin"
cp networkmanager_dmenu.desktop "$HOME/.local/share/applications/"
cd ..
rm -fr networkmanager-dmenu

# Install fonts
mkdir -p "$HOME/.local/share/fonts"
cp -rf "$BASEDIR/fonts/*" "$HOME/.local/share/fonts"

# Install cursor
sudo apt install breeze-cursor-theme

# Install icons
git clone https://github.com/vinceliuice/Tela-icon-theme.git --depth 1
cd Tela-icon-theme
./install.sh -a
cd ..
rm -fr Tela-icon-theme

# Install Themes
git clone https://github.com/ParrotSec/parrot-themes.git --depth 1
cd parrot-themes
mkdir -p "$HOME/.themes"
mv themes/* "$HOME/.themes"
cd ..
rm -fr parrot-themes


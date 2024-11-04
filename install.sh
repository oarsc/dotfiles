#!/bin/bash

BASEDIR=$(dirname $(readlink -e $0))
CONFIGDIR="$HOME/.config"

sudo apt install -y bspwm zsh sxhkd feh kitty dmenu polybar picom rofi xsecurelock scrot dunst jq keychain lm-sensors curl zsh pulseaudio pulseaudio-utils

mkdir -p "$CONFIGDIR/gtk-3.0"
rm -fr "$CONFIGDIR/bspwm" "$CONFIGDIR/sxhkd" "$CONFIGDIR/polybar" \
       "$CONFIGDIR/kitty" "$CONFIGDIR/picom" "$CONFIGDIR/gtk-3.0/settings.ini" \
       "$CONFIGDIR/zsh" "$HOME/.zshrc" "$HOME/.xprofile"

ln -s "$BASEDIR/bspwm"                "$CONFIGDIR/bspwm"
ln -s "$BASEDIR/sxhkd"                "$CONFIGDIR/sxhkd"
ln -s "$BASEDIR/polybar"              "$CONFIGDIR/polybar"
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

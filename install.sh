#!/bin/bash

BASEDIR=$(dirname "$0")
CONFIGDIR="$HOME/.config"

sudo apt install -y bspwm sxhkd feh kitty dmenu polybar picom rofi xsecurelock scrot dunst jq

mkdir -p "$CONFIGDIR/gtk-3.0"
rm -fr "$CONFIGDIR/bspwm" "$CONFIGDIR/sxhkd" "$CONFIGDIR/polybar" \
       "$CONFIGDIR/kitty" "$CONFIGDIR/picom" "$CONFIGDIR/gtk-3.0/settings.ini" \
       "$CONFIGDIR/zsh" "$HOME/.zshrc" "$HOME/.xprofile"

ln -s "$BASEDIR/bspwm"                "$CONFIGDIR/bspwm"
ln -s "$BASEDIR/sxhkd"                "$CONFIGDIR/sxhkd"
ln -s "$BASEDIR/polybar"              "$CONFIGDIR/polybar"
ln -s "$BASEDIR/kitty"                "$CONFIGDIR/kitty"
ln -s "$BASEDIR/picom"                "$CONFIGDIR/picom"
ln -s "$BASEDIR/gtk-3.0/settings.ini" "$CONFIGDIR/gtk-3.0/settings.ini"
ln -s "$BASEDIR/zsh"                  "$CONFIGDIR/zsh"
ln -s "$BASEDIR/dunst"                "$CONFIGDIR/dunst"
ln -s "$BASEDIR/.zshrc"               "$HOME/.zshrc"
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

# zsh Plugins
git clone https://github.com/rupa/z "$BASEDIR/zsh/plugins/z"

# Set default terminal
gsettings set org.cinnamon.desktop.default-applications.terminal exec kitty

# Nvim instructions
wget -O ./nvim-linux64.deb "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb"
sudo apt install -y xclip ./nvim-linux64.deb
rm ./nvim-linux64.deb

git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim

echo "- Please run \"nvim +PackerSync\" in order to finish configurating Astrovim"
echo "- If executing \"nvim ~/.nvimrc\" shows an error, execute \":TSInstall vim\" to solve it"
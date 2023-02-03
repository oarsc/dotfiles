#!/bin/bash

# Close repository
git clone https://github.com/vinceliuice/Tela-icon-theme.git --depth 1

# Install icons
cd Tela-icon-theme
./install.sh -a

# Remove used files
cd ..
rm -fr Tela-icon-theme
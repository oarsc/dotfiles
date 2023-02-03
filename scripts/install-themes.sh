#!/bin/bash

# Close repository
git clone https://github.com/ParrotSec/parrot-themes.git --depth 1

# Install themes
cd parrot-themes/themes
mv * ~/.themes

# Remove used files
cd ../..
rm -fr parrot-themes
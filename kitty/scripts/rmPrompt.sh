#!/bin/bash

file="$PWD/$1"

if [ -f "$file" ]; then
    echo "Do you want to delete this file? (y/n)"
    echo "$file"
    read -p "> " response

    if [ "$response" = "y" ]; then
        rm $file
        if [ $? -ne 0 ]; then
            read -p "Press Enter to exit"
        fi
    fi

elif [ -d "$file" ]; then
    echo "ERROR: \"$file\" is a directory"
    read -p "Press Enter to exit"
else
    echo "ERROR: \"$file\" does not exist"
    read -p "Press Enter to exit"
fi


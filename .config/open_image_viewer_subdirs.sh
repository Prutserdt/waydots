#!/bin/bash

# Find image files in current directory and underlaying ones and open in the nsxiv program
find . -type f \( -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' \) | sort | nsxiv -ftio

echo "The shell script open_image_viewer.sh was run."

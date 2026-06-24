#!/bin/bash

# Find image files in the current directory only.
# -maxdepth 1: no subdirectories
# -type f: regular files only
find . -maxdepth 1 -type f \( \
  -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' \
\) | sort | nsxiv -ftio

echo "The shell script open_image_viewer.sh was run."

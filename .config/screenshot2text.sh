#!/bin/sh
ramdir="/dev/shm/temp"

# Create the directory only if it does not exist
if [ ! -d "$ramdir" ]; then
    mkdir "$ramdir"
fi

screenshot_pic="$ramdir/wismij.jpg"
screenshot_txt="$ramdir/wismij"
xfce4-screenshooter -r -s "$screenshot_pic"
tesseract "$screenshot_pic" "$screenshot_txt"
cat "$screenshot_txt.txt" | wl-copy

#!/bin/sh
ramdir="/dev/shm/temp"
mkdir $ramdir 
screenshot_pic="$ramdir/wismij.jpg"
screenshot_txt="$ramdir/wismij"
xfce4-screenshooter -r -s $screenshot_pic
tesseract $screenshot_pic $screenshot_txt
cat $screenshot_txt.txt | wl-copy

#!/bin/env bash

rm "$HOME/.config/rofi/app_list.txt"
ls /usr/bin/* > "$HOME/.config/rofi/app_list.txt"
shopt -s nullglob  # Set nullglob before file assignment
FILES="$HOME/applications/"*.AppImage

for f in $FILES; do
    sed -i "1 i $f" "$HOME/.config/rofi/app_list.txt"
done

notify-send -t 1000 "A new list of installed applications is made 😃"

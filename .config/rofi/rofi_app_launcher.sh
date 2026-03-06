#!/bin/env bash

chosen=$(cat $HOME/.config/rofi/app_list.txt | rofi -dmenu -c -bw 2 -l 40 -i -p 'Run: ')

# Check if a choice was made
if [ -n "$chosen" ]; then
    # Launch the application
    notify-send -t 1000 "Starting application:" "$chosen"
    exec $chosen
fi

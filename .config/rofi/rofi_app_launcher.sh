#!/bin/env bash

chosen=$(find /usr/share/applications ~/.local/share/applications -name '*.desktop' | \
    awk -F'/' '{print $NF}' | sed 's/\.desktop//g' | rofi -dmenu -p 'Run' -i -l 40)

# Check if a choice was made
if [ -n "$chosen" ]; then
    # Launch the application
    notify-send -t 1000 "Starting application:" "$chosen"
    exec $chosen
fi

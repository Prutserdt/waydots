#!/bin/env bash

brave_workspace=""
bookmarks=("$HOME/stack/Command_line/urls")

# Create a formatted string for rofi input preserving order and empty lines
url=$(cat "${bookmarks[0]}" | rofi -i -dmenu -show -width 1500 -l 20 -p 'Bookmarks')

# Only proceed if a URL was selected
if [[ -n "$url" ]]; then
    output=$(hyprctl clients)

    hyprctl eval "hl.dispatch(hl.dsp.focus({ window = \"class:brave-browser\" }))"

    # Get the window ID of the Brave browser
    brave_window_id=$(echo "$output" | grep -i "Brave" | awk '{print $2}')

    # Open the URL
    if [[ -z "$brave_window_id" ]]; then
        brave --password-store=basic "$url"
    else
        brave --password-store=basic "$url"
    fi
fi

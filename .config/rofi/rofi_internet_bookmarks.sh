#!/bin/env bash

brave_window_id=""
brave_workspace=1

# My bookmark list
bookmarks=("$HOME/stack/Command_line/urls")

# Create a formatted string for rofi input preserving order and empty lines
url=$(cat "${bookmarks[0]}" | rofi -i -dmenu -show -width 1500 -l 20 -p 'Bookmarks')

# Get the workspace number of the Brave browser
output=$(hyprctl clients)
brave_workspace=$(echo "$output" | grep -A 7 -i "Brave" | grep "workspace:" | awk '{print $2}')

# Get the window ID of the Emacs client
brave_window_id=$(echo "$output" | grep -i "Brave" | awk '{print $2}')

# Check if the Emacs window ID is non-empty
if [[ -z "$brave_window_id" ]]; then
    #echo "No Emacs workspace found. Starting emacsclient..."
    brave --password-store=basic "$url"
else
    #echo "Switching to Emacs workspace $emacs_workspace and focusing on window $emacs_window_id..."
    hyprctl dispatch workspace "$brave_workspace"
    hyprctl dispatch focuswindow class:brave-browser
    brave --password-store=basic "$url"
fi

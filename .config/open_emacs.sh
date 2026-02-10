#!/bin/bash

emacs_window_id=""
emacs_workspace=1

# Get the workspace number of the Emacs client
output=$(hyprctl clients)
emacs_workspace=$(echo "$output" | grep -A 7 -i "Doom Emacs" | grep "workspace:" | awk '{print $2}')

# Get the window ID of the Emacs client
emacs_window_id=$(echo "$output" | grep -i "Doom Emacs" | awk '{print $2}')

# Check if the Emacs window ID is non-empty
if [[ -z "$emacs_window_id" ]]; then
    #echo "No Emacs workspace found. Starting emacsclient..."
    emacsclient -c -a "emacs"
else
    #echo "Switching to Emacs workspace $emacs_workspace and focusing on window $emacs_window_id..."
    hyprctl dispatch workspace "$emacs_workspace"
    hyprctl dispatch focuswindow class:Emacs
fi

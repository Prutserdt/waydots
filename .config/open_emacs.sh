#!/bin/bash

emacs_window_id=""
emacs_workspace=1

# Function to check if Emacs daemon is running
is_emacs_daemon_running() {
    pgrep -u "$USER" -f "emacs --daemon" > /dev/null
}

# Ensure Emacs daemon is running
if ! is_emacs_daemon_running; then
    emacs --daemon
fi

# Get the workspace number of the Emacs client
output=$(hyprctl clients)
emacs_workspace=$(echo "$output" | grep -A 7 -i "Doom Emacs" | grep "workspace:" | awk '{print $2}')

# Get the window ID of the Emacs client
emacs_window_id=$(echo "$output" | grep -i "Doom Emacs" | awk '{print $2}')

# Check if the Emacs window ID is non-empty
if [[ -z "$emacs_window_id" ]]; then
    emacsclient -c -a "emacs"
else
    hyprctl dispatch workspace "$emacs_workspace"
    hyprctl dispatch focuswindow class:Emacs
fi

#!/bin/bash

emacs_window_id=""

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

# Get the window ID of the Emacs client
# This assumes the window title contains `Doom Emacs`.
# The second field of the first line should be the window ID.
emacs_window_id=$(echo "$output" | grep -i "Doom Emacs" | awk '{print $2}')
echo "emacs_window_id: "$emacs_window_id

# Check if the Emacs window ID is non-empty
if [[ -z "$emacs_window_id" ]]; then
    emacsclient -c -a "emacs"
else
    hyprctl eval "hl.dispatch(hl.dsp.focus({ window = \"class:Emacs\" }))"
fi

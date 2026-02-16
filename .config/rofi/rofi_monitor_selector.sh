#!/bin/env bash

# Get the list of connected monitors
monitors=$(hyprctl monitors | awk '/Monitor/ {print $2}' | tr -d '()')

# Check if there are any monitors available
if [ -z "$monitors" ]; then
  echo "No monitors connected."
  exit 1
fi

# Display the list of monitors using Rofi
selected_monitor=$(echo "$monitors" | rofi -dmenu -p "Select a monitor:")

# Check if the user made a selection
if [ -n "$selected_monitor" ]; then
  echo "You selected: $selected_monitor"
  # You can add additional actions here
  # hyprctl some_command "$selected_monitor"
fi

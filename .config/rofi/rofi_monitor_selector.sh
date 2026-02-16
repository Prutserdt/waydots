#!/bin/env bash


# Get the list of connected monitors
monitors=$(hyprctl monitors | awk '/Monitor/ {print $2}' | tr -d '()')

# Check if there are any monitors available
if [ -z "$monitors" ]; then
  echo "No monitors connected. There must be an error, since you can read this text. "
  exit 1
fi

# Display the list of monitors using Rofi
selected_monitor=$(echo "$monitors" | rofi -dmenu -p "Select a monitor:")

# Check if the user made a selection
if [ -n "$selected_monitor" ]; then
  echo "You selected: $selected_monitor"
  
  # Disable all monitors except the selected one
  for monitor in $monitors; do
    if [ "$monitor" != "$selected_monitor" ]; then
      hyprctl monitor state "$monitor" off
    fi
  done
  
  # Optionally enable the selected monitor if needed
  hyprctl monitor state "$selected_monitor" on
fi

#!/usr/bin/env bash
# FIXME: this script does NOT WORK!

# Get the list of connected monitors
monitors=$(hyprctl monitors all| awk '/Monitor/ {print $2}' | tr -d '()')

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
  
  # Disable all monitors except the selected one
  for monitor in $monitors; do
    if [ "$monitor" != "$selected_monitor" ]; then
      hyprctl keyword monitor "$monitor.disable"
      echo "11111Disabled monitor: $monitor"
    fi
  done
  
  # Optionally enable the selected monitor if needed
  # hyprctl keyword monitor "$selected_monitor.enable"
  echo "Enabled monitor: $selected_monitor"
fi

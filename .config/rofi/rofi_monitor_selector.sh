#!/usr/bin/env bash

# Get the list of monitors
monitors=$(hyprctl monitors all | awk '{print $1}')

# Use Rofi to display the list
selected_monitor=$(echo "$monitors" | rofi -dmenu -p "Select Monitor:")

# Switch to the selected monitor
if [ -n "$selected_monitor" ]; then
    hyprctl dispatch focusmonitor "$selected_monitor"
fi

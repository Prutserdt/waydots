#!/bin/env bash

# Options for the menu
options="Logout\nShutdown\nReboot"

# Show the menu with Rofi
chosen=$(echo -e $options | rofi -dmenu -p "Quitting?")

# Execute the command based on the user's choice
case "$chosen" in
    "Logout")
        command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
        ;;
    "Shutdown")
        # Command to shutdown
        systemctl poweroff
        ;;
    "Reboot")
        # Command to reboot
        systemctl reboot
        ;;
    *)
        exit 1
        ;;
esac

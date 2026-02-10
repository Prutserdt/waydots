#!/bin/env bash

WALLPAPER_DIRECTORY="$HOME/stack/Afbeeldingen/Wallpapers"

# List all wallpapers and let Rofi handle the selection
WALLPAPER=$(find "$WALLPAPER_DIRECTORY" -maxdepth 1 -type f | rofi -dmenu -p "Select Wallpaper")

# Check if a wallpaper was selected
if [[ -n "$WALLPAPER" ]]; then
    echo $WALLPAPER 
    hyprctl hyprpaper preload "$WALLPAPER"
    hyprctl hyprpaper wallpaper "DP-1,$WALLPAPER"
    
    sleep 1

    hyprctl hyprpaper unload unused
else
    echo "No wallpaper selected."
fi

#!/bin/env bash

brave_workspace=""
bookmarks=("$HOME/stack/Command_line/urls")

# Create a formatted string for rofi input preserving order and empty lines
url=$(cat "${bookmarks[0]}" | rofi -i -dmenu -show -width 1500 -l 20 -p 'Bookmarks')

# Only proceed if a URL was selected
if [[ -n "$url" ]]; then
    output=$(hyprctl clients)
    #echo "_____________"
    #echo "$output"
    # Find all workspace numbers occupied by Brave windows
    workspaces=($(echo "$output" | awk '/Window .* -> .* - Brave:/{found=1; next} found && /workspace:/{print $2; found=0}'))
    #echo "_____________"
    #echo "My workspaces are:$workspaces"

    # Get the current workspace
    current_workspace=$(hyprctl activeworkspace -j | jq '.id')
    #echo "_____________"
    #echo "My current workspace is: $current_workspace"

    # Check if Brave is already open in the current workspace
    braves_in_current_workspace=$(echo "$output" | grep -i "Brave" | grep "workspace: $current_workspace")
    #echo "---------"
    #echo "brave_in_current_workspace:$brave_in_current_workspace"

    # Determine where to open the URL
    if [[ -n "$braves_in_current_workspace" ]]; then
        # If Brave is open in the current workspace
        hyprctl dispatch focuswindow class:brave-browser
    else
        # Find the lowest workspace number if not open in the current workspace
        # 
        if [[ ${#workspaces[@]} -gt 0 ]]; then
            brave_workspace=$(printf "%s\n" "${workspaces[@]}" | sort -n | head -n 1)
            #echo "---------"
            #echo "brave_workspace after sorting :$brave_workspace"
            hyprctl dispatch workspace "$brave_workspace"
        fi
    fi

    # Get the window ID of the Brave browser
    brave_window_id=$(echo "$output" | grep -i "Brave" | awk '{print $2}')

    # Open the URL
    if [[ -z "$brave_window_id" ]]; then
        brave --password-store=basic "$url"
    else
        brave --password-store=basic "$url"
    fi
fi

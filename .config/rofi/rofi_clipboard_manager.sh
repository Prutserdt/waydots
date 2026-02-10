#!/bin/env bash

while true; do
    # Get the list of clipboard history and prompt for selection
    selection=$(cliphist list | rofi -dmenu -p "Select clipboard item")

    # Exit if nothing is selected or ESC is pressed
    if [[ -z "$selection" ]]; then
        exit
    fi

    # Decode the selected clipboard item
    decoded_item=$(echo "$selection" | cliphist decode)

    while true; do
        # Provide options for further actions
        option=$(echo -e "Make selection primary clipboard\nDelete entry from history\nShow selected text\nGo back to clipboard selection (ESC to go back)" | rofi -dmenu -p "Choose action")

        # Check if ESC is pressed (empty input)
        if [[ -z "$option" ]]; then
            break  # Exit the inner loop to go back to the clipboard selection
        fi

        case "$option" in
            "Make selection primary clipboard")
                echo "$decoded_item" | wl-copy
                break  # Exit the inner loop and go back to the clipboard selection
                ;;
            "Delete entry from history(FIXMEdoes not work yet!)")
                cliphist delete "$decoded_item"
                break  # Exit the inner loop and go back to the clipboard selection
                ;;
            "Show selected text")
                echo "$decoded_item" | rofi -dmenu -p "Selected text" -width 800 -height 600
                ;;
            "Go back to clipboard selection")
                break  # Exit the inner loop to go back to the clipboard selection
                ;;
            *)
                echo "No valid option selected."
                ;;
        esac
    done
done

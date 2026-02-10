#!/bin/bash

selected=$(ps -a -u "$USER" | rofi -dmenu -p "Process: delete, copy PID, copy name, or exit")
pid=$(echo "$selected" | awk '{print $1}')
process_name=$(echo "$selected" | awk '{for(i=4;i<=NF;i++) printf $i " "; print ""}')

if [ -n "$pid" ]; then
    option=$(echo -e "Delete Process\nCopy PID to Clipboard\nCopy Process Name to Clipboard\nExit" | rofi -dmenu -p "Choose an option:")

    case "$option" in
        "Delete Process")
            kill "$pid"
            ;;
        "Copy PID to Clipboard")
            echo -n "$pid" | wl-copy
            ;;
        "Copy Process Name to Clipboard")
            echo -n "$process_name" | wl-copy
            ;;
        "Exit")
            exit 0
            ;;
        *)
            echo "No valid option selected."
            ;;
    esac
else
    echo "No process selected."
fi

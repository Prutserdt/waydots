#!/bin/env bash

# FIXME: I want to get rid of the sudo line and give specific access to directoryies to mount to.
#        In Wayland the graphical window with sudo rights are not permitted 

# Show main menu options
show_main_menu() {
    action=$(printf "Mount\nUnmount\nShow Drives" | rofi -dmenu -p "Choose action")
}

# Display available drives
show_drives() {
    lsblk -o NAME,SIZE,MOUNTPOINT | rofi -dmenu -p "Only showing the available drives, escape to go back to the menu" -no-custom
}

# Main loop
while true; do
    show_main_menu

    # Exit if no action is selected
    [ -z "$action" ] && { notify-send "No action selected"; exit 1; }

    # Show drives if selected
    if [[ "$action" == "Show Drives" ]]; then
        selected_drive=$(show_drives)
        [ $? -ne 0 ] && continue  # Return to main menu if Escape was pressed
        
        [ -n "$selected_drive" ] || { notify-send "No drive selected"; continue; }
        action="Mount"  # Default to Mount after showing drives
    fi

    # Get partitions and prepare options
    options=$(lsblk -o NAME,SIZE,MOUNTPOINT | awk -v action="$action" '
        action == "Unmount" { if ($3 != "") print $1, $2, $3; }
        action == "Mount" { print $1, $2; }
    ')

    # Present menu to select partition
    selected=$(printf '%s\n' "$options" | rofi -dmenu -p "Select partition to $action:" -no-custom)

    # Extract device name and remove glyphs
    device_name=$(echo "$selected" | awk '{print $1}' | sed 's/[^a-zA-Z0-9]//g')
    #echo "$device_name"
    
    # Handle mount/unmount actions
    if [ -n "$device_name" ]; then
        case "$action" in
            Mount)
                mount_point="/mnt/$device_name"
                sudo mkdir -p "$mount_point"
                sudo mount "/dev/$device_name" "$mount_point" && \
                notify-send "Mounted $device_name to $mount_point" || \
                notify-send "Failed to mount $device_name"
                ;;
            Unmount)
                mount_point="/mnt/$device_name"
                if [ -n "$mount_point" ]; then
                    sudo umount "$mount_point" && \
                    notify-send "Unmounted $device_name from $mount_point" || \
                    notify-send "Failed to unmount $device_name"
                else
                    notify-send "No mount point found for $device_name"
                fi
                ;;
        esac
    else
        notify-send "No device selected"
    fi
done

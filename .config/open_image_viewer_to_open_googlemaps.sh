#!/usr/bin/env bash

notify() {
    notify-send -t 60000 "Image GPS Location" "$1"
}

mapfile -t image_files < <(
    find . -maxdepth 1 -type f \
        \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) \
        -print | sort
)

if [ "${#image_files[@]}" -eq 0 ]; then
    notify "No image files found."
    exit 1
fi

while true; do
    selected_image=$(
        printf '%s\n' "${image_files[@]}" | nsxiv -ftio
    )

    # Exit if nsxiv was closed without selecting an image.
    if [ -z "$selected_image" ]; then
        notify "No image was selected."
        exit 1
    fi

    gps_position=$(
        exiftool -s3 -GPSPosition "$selected_image" 2>/dev/null
    )

    # Return to nsxiv if the image has no GPS data.
    if [ -z "$gps_position" ]; then
        notify "Sorry, there is no GPS data in the picture."
        continue
    fi

    picture_name=$(basename -- "$selected_image")
    url_gps_position=${gps_position// /%20}
    maps_url="https://www.google.com/maps/search/?api=1&query=$url_gps_position"

    xdg-open "$maps_url" >/dev/null 2>&1 &

    mkdir -p "$PWD/locations"

    printf '%s, %s\n' "$picture_name" "$gps_position" \
        >> "$PWD/locations/locations.csv"

    notify "Picture: $picture_name
GPS location: $gps_position

The location was saved to:
$PWD/locations/locations.csv"

    exit 0
done

#!/bin/bash 

# Find image files in the current directory (non-recursive),
# matching common image extensions, then sort them.
image_files=$(find . -maxdepth 1 -type f \
  \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.png" -o -iname "*.gif" \) \
  | sort)

# Show the list in nsxiv and let the user select one.
selected_image=$(echo "$image_files" | nsxiv -ftio)

# If no image was selected, stop.
if [ -z "$selected_image" ]; then
  echo "Sorry, there is no exif data in the picture"
  exit 1
fi

# Extract the GPS Position line from the image metadata.
exif_info=$(exiftool "$selected_image" | grep "GPS Position")

# If there is no GPS metadata, stop.
if [ -z "$exif_info" ]; then
  echo "Sorry, there is no exif data in the picture"
  exit 1
fi

# Pull out just the GPS coordinates from the exif output.
gps_position=$(echo "$exif_info" | awk -F ": " '{print $2}' | tr -d " " | sed 's/deg/°/g')

# Build the Google Maps URL using the GPS coordinates.
maps_url="https://www.google.com/maps/place/$gps_position"

# Open the location in the default browser.
xdg-open "$maps_url"

# Notify the user that Google Maps was opened.
notify-send -t 60000 "Google maps opened with GPS location: $gps_position"

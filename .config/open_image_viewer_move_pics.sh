#!/bin/zsh

destination_folder="Minder_en_dubbelop"

selected_images=()
moved_images=()

echo "The shell script open_image_viewer_move_pics.sh was run and here are the results."

# Run find once
image_list=$(find . -maxdepth 1 -type f \
  \( -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' \) \
  | sort)

# Count images
image_count=$(printf '%s\n' "$image_list" | sed '/^$/d' | wc -l)
echo "Found $image_count image files (jpeg/jpg/png/gif) in the directory."

# Pick images
while IFS= read -r image_file; do
  [[ -n "$image_file" ]] && selected_images+=("$image_file")
done < <(printf '%s\n' "$image_list" | nsxiv -tio)

number_moved=0

# Move the nsxiv selected images to the destination folder
for image_file in "${selected_images[@]}"; do
  if [[ -n "$image_file" ]] && mv -- "$image_file" "$destination_folder/"; then
    moved_images+=("$image_file")
    ((number_moved++))
  fi
done

# Give information
if (( number_moved > 0 )); then
  echo "Moved files to directory '$destination_folder':"
  for image_file in "${moved_images[@]}"; do
    echo "$image_file"
  done
  echo "Total number of files moved: $number_moved"
else
  echo "No files were moved."
fi

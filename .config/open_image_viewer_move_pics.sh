#!/bin/bash

# Find image files in the current directory only.
# -maxdepth 1   -> do not search inside subdirectories
# -type f       -> only regular files
# \( ... \)     -> group the extension tests together
# -o            -> logical OR between the filename patterns
#
# Open the images in nsxiv as thumbnails and let the user select files.
# -t  -> thumbnail mode
# -i  -> interactive selection
# -o  -> output selected file paths
# nsxiv prints the chosen files to stdout, one per line
# Read each selected file path safely, one per line.
# IFS= and -r prevent trimming and backslash escaping issues.
find . -maxdepth 1 -type f \
  \( \
    -iname '*.jpeg' -o \
    -iname '*.jpg'  -o \
    -iname '*.png'  -o \
    -iname '*.gif' \
  \) | sort | nsxiv -tio | while IFS= read -r file; do
    mv -- "$file" Minder_en_dubbelop/
done

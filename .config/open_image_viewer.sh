#!/bin/bash 

# Find image files in the current directory only.
# -maxdepth 1   -> do not search inside subdirectories
# -type f       -> only regular files
# \( ... \)     -> group the extension tests together
# -o            -> logical OR between the filename patterns
find . -maxdepth 1 -type f \( \
  -iname '*.jpeg' -o \
  -iname '*.jpg'  -o \
  -iname '*.png'  -o \
  -iname '*.gif' \
\) \
| sort \
| nsxiv -ftio

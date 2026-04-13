#!/bin/bash 

# Find image files in current directory and underlaying ones.
# -type f       -> only regular files
# \( ... \)     -> group the extension tests together
# -o            -> logical OR between the filename patterns
find . -type f \( \
  -iname '*.jpeg' -o \
  -iname '*.jpg'  -o \
  -iname '*.png'  -o \
  -iname '*.gif' \
\) \
| sort \
| nsxiv -ftio

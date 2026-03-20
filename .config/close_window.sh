#!/bin/bash

# Get the class of the currently focused window
focused_class=$(hyprctl clients | grep -A 7 -i "focused" | grep "class:" | awk '{print $2}')

# If emacs is there it should not be brutely terminated
if [[ "$focused_class" == "Emacs" ]]; then
    emacsclient -e "(kill-terminal)"
else
    hyprctl dispatch killactive
fi

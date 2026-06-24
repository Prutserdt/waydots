#!/bin/bash

focused_class=$(hyprctl clients -j | jq -r '.[] | select(.focused == true) | .class')

if [[ "$focused_class" == "Emacs" ]]; then
    emacsclient -e '(if (get-buffer "*terminal*") (kill-buffer "*terminal*"))'
else
    #hyprctl dispatch closewindow
    hyprctl dispatch 'hl.dsp.window.close()'   
fi




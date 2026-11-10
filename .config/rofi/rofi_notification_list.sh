#!/usr/bin/env bash

notification=$(
    dunstctl history --json |
        jq -r '
            .data[][]
            | [
                (.summary.data // ""),
                (.body.data // "")
              ]
            | map(select(length > 0))
            | join(": ")
            | gsub("<[^>]+>"; "")
            | gsub("\n"; " — ")
        ' |
        rofi \
            -dmenu \
            -i \
            -no-custom \
            -p "Notifications" \
            -mesg "Select a line (enter) to copy it to the system clipboard"
)

if [[ -n "$notification" ]]; then
    printf '%s' "$notification" | wl-copy
fi

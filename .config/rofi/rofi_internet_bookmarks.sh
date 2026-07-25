#!/bin/env bash

bookmark_file="$HOME/stack/Command_line/urls"

printf "Using Rofi to open websites...\n"
notify-send -t 1000 "Rofi bookmarks" "Waiting for a choice"

url=$(rofi -i -dmenu -width 1500 -l 20 -p "Bookmarks" < "$bookmark_file")

if [[ -z "$url" ]]; then
    printf "No bookmark selected.\n"
    notify-send -t 20000 "Rofi bookmarks" "No bookmark selected."
    exit 0
fi

printf "Selected URL: %s\n" "$url"
notify-send "Rofi bookmarks" "Selected: $url"

# Get Brave window + workspace with the lowest workspace number
read -r brave_workspace brave_window_address < <(
    hyprctl clients -j | jq -r '
        [ .[]
          | select(.class | test("brave-browser"; "i"))
          | {workspace: (.workspace.id // 999999), address: .address}
        ]
        | sort_by(.workspace)
        | .[0]
        | "\(.workspace) \(.address)"
    '
)

if [[ -n "$brave_workspace" && -n "$brave_window_address" ]]; then
    printf "Found Brave window: %s on workspace %s\n" "$brave_window_address" "$brave_workspace"
    notify-send -t 20000 "Rofi bookmarks" "Found Brave on workspace $brave_workspace"

    # Switch to the workspace first. To escape the double quotes use  \ and \
    hyprctl dispatch "hl.dsp.focus({ workspace = \"$brave_workspace\" })"

    # FIXME: focus on window does not work!
    hyprctl dispatch "hl.dsp.focus({ window = \"$brave_window_address\" })"
        
    # Open the URL in the existing Brave instance
    brave --new-tab "$url" >/dev/null 2>&1 &
else
    printf "No Brave window found. Launching Brave...\n"
    notify-send -t 20000 "Rofi bookmarks" "No Brave window found. Launching Brave..."
    brave --new-tab "$url" >/dev/null 2>&1 &
fi

printf "Opened URL in Brave: %s\n" "$url"
notify-send -t 20000 "Rofi bookmarks" "Opened URL in Brave."

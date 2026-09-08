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

# Ask for search input if the selected URL is a search engine
search_query=""

if [[ "$url" == *"duckduckgo.com"* || "$url" == *"search.brave.com"* || "$url" == *"google.com"* || "$url" == *"youtube.com"* ]]; then
    search_query=$(rofi -i -dmenu -width 1200 -l 1 -p "Search words")
    printf "Search query: %s\n" "$search_query"
    notify-send "Rofi bookmarks" "Search: $search_query"
fi

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

# Build final URL
final_url="$url"
if [[ -n "$search_query" ]]; then
    if [[ "$url" == *"duckduckgo.com"* ]]; then
        final_url="${url%/}/?q=$(printf '%s' "$search_query" | jq -sRr @uri)"
    elif [[ "$url" == *"google.com"* ]]; then
        final_url="${url%/}/search?q=$(printf '%s' "$search_query" | jq -sRr @uri)"
    elif [[ "$url" == *"youtube.com"* ]]; then
        final_url="https://www.youtube.com/results?search_query=$(printf '%s' "$search_query" | jq -sRr @uri)"
    elif [[ "$url" == *"search.brave.com"* ]]; then
        final_url="${url%/}/search?q=$(printf '%s' "$search_query" | jq -sRr @uri)"
    fi
fi

if [[ -n "$brave_workspace" && -n "$brave_window_address" ]]; then
    printf "Found Brave window: %s on workspace %s\n" "$brave_window_address" "$brave_workspace"
    notify-send -t 20000 "Rofi bookmarks" "Found Brave on workspace $brave_workspace"

    hyprctl dispatch "hl.dsp.focus({ workspace = \"$brave_workspace\" })"
    hyprctl dispatch "hl.dsp.focus({ window = \"$brave_window_address\" })"

    brave --new-tab "$final_url" >/dev/null 2>&1 &
else
    printf "No Brave window found. Launching Brave...\n"
    notify-send -t 20000 "Rofi bookmarks" "No Brave window found. Launching Brave..."
    brave --new-tab "$final_url" >/dev/null 2>&1 &
fi

printf "Opened URL in Brave: %s\n" "$final_url"
notify-send -t 20000 "Rofi bookmarks" "Opened URL in Brave."

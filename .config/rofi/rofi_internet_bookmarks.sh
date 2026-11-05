#!/usr/bin/env bash

bookmark_file="$HOME/stack/Command_line/urls"
manual_entry="Enter URL manually..."

notification_message="No bookmark selected."
selected_url=""
search_query=""

while true; do
    printf "Using Rofi to open websites...\n"

    url=$(
        {
            printf '%s\n' "$manual_entry"
            cat "$bookmark_file"
        } | rofi -i -dmenu -width 1500 -l 20 -p "Bookmarks"
    )

    if (( $? != 0 )); then
        notification_message="No bookmark selected."
        break
    fi

    if [[ "$url" == "$manual_entry" ]]; then
        url=$(rofi -i -dmenu -width 1200 -l 1 -p "Enter URL")

        if (( $? != 0 || -z "$url" )); then
            continue
        fi
    fi

    search_query=""

    if [[ "$url" == *"duckduckgo.com"* ||
          "$url" == *"search.brave.com"* ||
          "$url" == *"google.com"* ||
          "$url" == *"youtube.com"* ]]; then

        search_query=$(rofi -i -dmenu -width 1200 -l 1 -p "Search words")

        if (( $? != 0 || -z "$search_query" )); then
            continue
        fi
    fi

    selected_url="$url"
    break
done

if [[ -z "$selected_url" ]]; then
    notify-send -t 5000 "Rofi bookmarks" "$notification_message"
    exit 0
fi

# Find the Brave window on the workspace with the lowest workspace number.
brave_workspace=""
brave_window_address=""

read -r brave_workspace brave_window_address < <(
    hyprctl clients -j | jq -r '
        [
            .[]
            | select(.class | test("brave-browser"; "i"))
            | {
                workspace: (.workspace.id // 999999),
                address: .address
            }
        ]
        | sort_by(.workspace)
        | .[0] // empty
        | "\(.workspace) \(.address)"
    '
)

# Build the final URL.
final_url="$selected_url"

if [[ -n "$search_query" ]]; then
    encoded_query=$(printf '%s' "$search_query" | jq -sRr @uri)

    case "$selected_url" in
        *duckduckgo.com*)
            final_url="${selected_url%/}/?q=$encoded_query"
            ;;

        *google.com*)
            final_url="${selected_url%/}/search?q=$encoded_query"
            ;;

        *youtube.com*)
            final_url="https://www.youtube.com/results?search_query=$encoded_query"
            ;;

        *search.brave.com*)
            final_url="${selected_url%/}/search?q=$encoded_query"
            ;;
    esac
fi

if [[ -n "$brave_workspace" && -n "$brave_window_address" ]]; then
    printf "Found Brave window: %s on workspace %s\n" \
        "$brave_window_address" "$brave_workspace"

    hyprctl dispatch \
        "hl.dsp.focus({ workspace = \"$brave_workspace\" })"

    hyprctl dispatch \
        "hl.dsp.focus({ window = \"$brave_window_address\" })"

    brave --new-tab "$final_url" >/dev/null 2>&1 &

    notification_message="Opened URL in Brave on workspace $brave_workspace."
else
    printf "No Brave window found. Launching Brave...\n"

    brave --new-tab "$final_url" >/dev/null 2>&1 &

    notification_message="No Brave window found. Launched Brave."
fi

printf "Opened URL in Brave: %s\n" "$final_url"

# The only notification in the script.
notify-send -t 5000 "Rofi bookmarks" "$notification_message"

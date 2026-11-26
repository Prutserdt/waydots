#!/usr/bin/env bash

FILTER=""

while true; do
    FILE=$(
        find "$HOME" -type f \
            -not -path "$HOME/.cache/*" \
            2>/dev/null |
        rofi -dmenu \
            -i \
            -p "Search for file ($HOME)" \
            -filter "$FILTER"
    )

    # Exit when the file-selection screen is cancelled.
    [ -z "$FILE" ] && exit 0

    # Keep this file selected when returning to the file list.
    FILTER="$FILE"

    DIR=$(dirname -- "$FILE")
    NAME=$(basename -- "$FILE")

    ACTION=$(
        printf '%s\n' \
            "Open terminal and paste filename" \
            "Copy dirname and basename" \
            "Show file in rofi" \
            "Search again" |
        rofi -dmenu \
            -i \
            -p "$NAME"
    )

    case "$ACTION" in
        "Open terminal and paste filename")
            printf '%s' "$NAME" | wl-copy

            ghostty \
                --working-directory="$DIR" \
                >/dev/null 2>&1 &

            sleep 0.5

            wtype -M ctrl -M shift v -m shift -m ctrl
            exit 0
            ;;

        "Copy dirname and basename")
            {
                printf '%s\n' "$DIR"
                printf '%s\n' "$NAME"
            } | wl-copy

            exit 0
            ;;

        "Show file in rofi")
            cat -- "$FILE" |
                rofi -dmenu \
                    -i \
                    -no-custom \
                    -no-sort \
                    -p "$NAME"

            PREVIEW_ACTION=$(
                printf '%s\n' \
                    "Copy file contents to clipboard" \
                    "Return to file list" |
                rofi -dmenu \
                    -i \
                    -p "$NAME"
            )

            case "$PREVIEW_ACTION" in
                "Copy file contents to clipboard")
                    wl-copy < "$FILE"
                    ;;

                "Return to file list"|"")
                    ;;

                *)
                    exit 0
                    ;;
            esac

            continue
            ;;

        "Search again")
            FILTER=""
            continue
            ;;

        *)
            exit 0
            ;;
    esac
done

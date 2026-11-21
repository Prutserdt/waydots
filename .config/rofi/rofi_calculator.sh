#!/usr/bin/env bash

previous_expression=""

while true; do
    if [[ -n "$previous_expression" ]]; then
        expression=$(
            rofi -dmenu \
                -p "Calculate" \
                -filter "$previous_expression"
        )
    else
        expression=$(
            rofi -dmenu \
                -p "Calculate"
        )
    fi

    # Exit when Rofi is cancelled or input is empty
    [[ -z "$expression" ]] && exit 0

    # Allow only calculator characters
    if [[ ! "$expression" =~ ^[-0-9+*/%().^[:space:]]+$ ]]; then
        rofi -e "Invalid expression"
        previous_expression="$expression"
        continue
    fi

    # Calculate the expression
    result=$(
        printf 'scale=10;\n%s\n' "$expression" |
            bc -l 2>&1
    )

    # Check for calculation errors
    if [[ "$result" == *"error"* ||
          "$result" == *"Error"* ||
          "$result" == *"syntax"* ||
          "$result" == *"Syntax"* ]]; then
        rofi -e "Calculation error: $result"
        previous_expression="$expression"
        continue
    fi

    # Remove unnecessary trailing zeroes
    result=$(
        printf '%s\n' "$result" |
            sed -E \
                -e 's/(\.[0-9]*[1-9])0+$/\1/' \
                -e 's/\.0+$//' \
                -e 's/\.$//'
    )

    # Copy the result to the Wayland clipboard
    if command -v wl-copy >/dev/null 2>&1; then
        printf '%s' "$result" | wl-copy
    fi

    # Show only one option, with no empty line
    choice=$(
        printf '%s\n' "Calculate again" |
            rofi -dmenu \
                -p "$expression = $result"
    )

    case "$choice" in
        "Calculate again")
            previous_expression="$expression"
            ;;
        *)
            exit 0
            ;;
    esac
done

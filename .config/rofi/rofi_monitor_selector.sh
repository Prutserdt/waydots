#!/usr/bin/env bash

set -u

# Dependencies
for cmd in hyprctl jq rofi; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: '$cmd' is required but not installed." >&2
        exit 1
    fi
done

# Get connected monitor names
mapfile -t monitors < <(
    hyprctl monitors -j | jq -r '.[].name'
)

if ((${#monitors[@]} == 0)); then
    echo "No monitors connected."
    exit 1
fi

# Let the user select a monitor
selected_monitor=$(
    printf '%s\n' "${monitors[@]}" |
        rofi -dmenu -i -p "Select a monitor:"
)

# Exit if the selection was cancelled
if [[ -z "$selected_monitor" ]]; then
    exit 0
fi

# Escape the monitor name for the eval expression
escape_for_eval() {
    local value=$1
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    printf '%s' "$value"
}

set_monitor_state() {
    local monitor=$1
    local disabled=$2
    local escaped_monitor
    local expression

    escaped_monitor=$(escape_for_eval "$monitor")
    expression="hl.monitor({ output = \"$escaped_monitor\", disabled = $disabled })"

    echo "Setting $monitor: disabled=$disabled"

    if ! hyprctl eval "$expression"; then
        echo "Error: failed to update monitor '$monitor'." >&2
        return 1
    fi
}

echo "Selected monitor: $selected_monitor"

# Disable every monitor except the selected one
for monitor in "${monitors[@]}"; do
    if [[ "$monitor" != "$selected_monitor" ]]; then
        set_monitor_state "$monitor" true || exit 1
    fi
done

# Ensure the selected monitor is enabled
set_monitor_state "$selected_monitor" false

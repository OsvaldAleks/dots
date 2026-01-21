#!/bin/bash

DIRECTION="$1"
TARGET="main"

# Get if any monitor has special:$TARGET open
OPEN_ON_ANY=$(hyprctl -j monitors | jq -r \
  '.[] | select(.specialWorkspace.name == "special:'$TARGET'") | .specialWorkspace.name')

# Up = open if not open
if [[ "$DIRECTION" == "up" ]]; then
    if [[ -z "$OPEN_ON_ANY" ]]; then
        hyprctl dispatch togglespecialworkspace "$TARGET"
    fi

# Down = close if open
elif [[ "$DIRECTION" == "down" ]]; then
    if [[ -n "$OPEN_ON_ANY" ]]; then
        hyprctl dispatch togglespecialworkspace "$TARGET"
    else
        hyprctl dispatch killactive
    fi
fi
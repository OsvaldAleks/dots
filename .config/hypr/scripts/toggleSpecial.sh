#!/bin/bash

DIRECTION="$1"
TARGET="main"

# Get if any monitor has special:$TARGET open
OPEN_ON_FOCUSED=$(hyprctl -j monitors | jq -r \
  '.[] 
   | select(.focused == true and .specialWorkspace.name == "special:'"$TARGET"'") 
   | .specialWorkspace.name')

IS_ACTIVE=$(hyprctl -j activewindow | jq -r \
  'select(.workspace.name == "special:main") | .workspace.name')

# Up = open if not open
if [[ "$DIRECTION" == "up" ]]; then
    if [[ -z "$OPEN_ON_FOCUSED" ]]; then
        hyprctl dispatch togglespecialworkspace "$TARGET"
    fi

# Down = close if open
elif [[ "$DIRECTION" == "down" ]]; then
    if [[ -n "$OPEN_ON_FOCUSED" ]]; then
        hyprctl dispatch togglespecialworkspace "$TARGET"
    elif [[ -z "$IS_ACTIVE" ]];then
        hyprctl dispatch killactive
    fi
fi

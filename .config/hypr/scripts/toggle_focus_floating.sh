#!/usr/bin/env bash

# Get floating state of active window
FLOATING=$(hyprctl activewindow -j | jq '.floating')

if [ "$FLOATING" = "true" ]; then
    hyprctl dispatch focuswindow tiled
else
    hyprctl dispatch focuswindow floating
fi


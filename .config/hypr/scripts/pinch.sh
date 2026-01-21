#!/bin/bash

handleIn() {
    # Get active window info
    wininfo=$(hyprctl activewindow -j)
    isfloating=$(echo "$wininfo" | jq -r '.floating')
    isfullscreen=$(echo "$wininfo" | jq -r '.fullscreen')

    if [ "$isfloating" == "true" ]; then
        # If it's floating -> tile it
        hyprctl dispatch togglefloating
    elif [ "$isfullscreen" == "0" ]; then
        # If it's tiled -> fullscreen it
        hyprctl dispatch fullscreen
    fi
}

handleOut() {
    # Get active window info
    wininfo=$(hyprctl activewindow -j)
    isfullscreen=$(echo "$wininfo" | jq -r '.fullscreen')
    isfloating=$(echo "$wininfo" | jq -r '.floating')

    if [ "$isfullscreen" -gt 0 ]; then
        # If it's fullscreen -> undo fullscreen
        hyprctl dispatch fullscreen
    elif [ "$isfloating" == "false" ]; then
        # If it's tiled -> float it
        hyprctl dispatch togglefloating
    fi
}

if [ "$1" == "in" ]; then
    handleIn
elif [ "$1" == "out" ]; then
    handleOut
fi
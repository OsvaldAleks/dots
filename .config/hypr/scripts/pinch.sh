#!/bin/bash
TARGET="main"
# Get if any monitor has special:$TARGET open
SPECIAL_OPEN_ON_ANY=$(hyprctl -j monitors | jq -r \
  '.[] | select(.specialWorkspace.name == "special:'$TARGET'") | .specialWorkspace.name')
STATEFILE="/tmp/hyprexpo_active"

handleIn() {
    # Get active window info
    wininfo=$(hyprctl activewindow -j)
    isfloating=$(echo "$wininfo" | jq -r '.floating')
    isfullscreen=$(echo "$wininfo" | jq -r '.fullscreen')

    if [ "$isfloating" == "true" ]; then
        # If it's floating -> tile it
        hyprctl dispatch togglefloating
    else
        # If it's tiled -> fullscreen it

        # If it's the only window on current workspace skip maximize
        workspace=$(echo "$wininfo" | jq -r '.workspace.id')
        numWindows=$(hyprctl workspaces -j | jq -r '.[] | select(.id == '$workspace') | .windows')

        if [ "$numWindows" -eq 1 ]; then
            if [ "$isfullscreen" -lt 2 ]; then
                hyprctl dispatch fullscreenstate 2
            fi
        else
            hyprctl dispatch fullscreenstate $((isfullscreen + 1))
        fi
    fi
}


handle3in() {
    if [ -f "$STATEFILE" ]; then
        # HyprExpo is active -> select hovered workspace
        hyprctl dispatch hyprexpo:expo select
        rm "$STATEFILE"
    else
        # HyprExpo not active -> only open menu if Fuzzel is not running
        if ! pgrep -x fuzzel >/dev/null; then
            fuzzel --show drun
        fi
    fi
}

handleOut() {
    # Get active window info
    wininfo=$(hyprctl activewindow -j)
    isfullscreen=$(echo "$wininfo" | jq -r '.fullscreen')
    isfloating=$(echo "$wininfo" | jq -r '.floating')

    if [ "$isfullscreen" -gt 0 ]; then
        # If it's fullscreen -> undo fullscreen

        # If it's the only window on current workspace skip maximize
        workspace=$(echo "$wininfo" | jq -r '.workspace.id')
        numWindows=$(hyprctl workspaces -j | jq -r '.[] | select(.id == '$workspace') | .windows')

        if [ "$numWindows" -eq 1 ]; then
            hyprctl dispatch fullscreenstate 0
        else
            hyprctl dispatch fullscreenstate $((isfullscreen - 1))
        fi

    elif [ "$isfloating" = "false" ]; then
        # If it's tiled -> float it
        hyprctl dispatch togglefloating
    fi
}

handle3out() {
    # Only toggle HyprExpo if Fuzzel is not running
    if ! pgrep -x fuzzel >/dev/null; then
        hyprctl dispatch hyprexpo:expo toggle
        if [[ ! -z "$SPECIAL_OPEN_ON_ANY" ]]; then
            hyprctl dispatch togglespecialworkspace "$TARGET"
        fi
        touch "$STATEFILE"
        hyprctl dispatch hyprexpo:expo on
    else
        pkill fuzzel
    fi
}

if [ "$1" == "in" ]; then
    handleIn
elif [ "$1" == "out" ]; then
    handleOut
elif [ "$1" == "3in" ]; then
    handle3in
elif [ "$1" == "3out" ]; then
    handle3out
fi

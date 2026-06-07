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
        hyprctl dispatch 'hl.dsp.window.float()'
    else
        # If it's tiled -> fullscreen it

        # If it's the only window on current workspace skip maximize
        workspace=$(echo "$wininfo" | jq -r '.workspace.id')
        numWindows=$(hyprctl workspaces -j | jq -r '.[] | select(.id == '$workspace') | .windows')

        if [ "$numWindows" -eq 1 ]; then
            if [ "$isfullscreen" -lt 2 ]; then
                hyprctl dispatch 'hl.dsp.window.fullscreen_state( { internal = 2, client = -1})'
            fi
        else
            hyprctl dispatch 'hl.dsp.window.fullscreen_state( { internal = '$((isfullscreen + 1))', client = -1})'
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
            hyprctl dispatch 'hl.dsp.window.fullscreen_state( { internal = 0, client = -1})'
        else
            hyprctl dispatch 'hl.dsp.window.fullscreen_state( { internal = '$((isfullscreen - 1))', client = -1})'
        fi

    elif [ "$isfloating" = "false" ]; then
        # If it's tiled -> float it
        hyprctl dispatch 'hl.dsp.window.float()'
    fi
}

if [ "$1" == "in" ]; then
    handleIn
elif [ "$1" == "out" ]; then
    handleOut
fi

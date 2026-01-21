#!/usr/bin/env bash

enable_move() {
    # Get info about the currently focused window
    focused_window=$(hyprctl activewindow -j)

    # Check if it is floating
    is_floating=$(echo "$focused_window" | jq -r '.floating')


    if [ "$is_floating" = "true" ]; then
        # Activate move submap
        notify-send -r 123 -t 0 -a "status" "Active submap" "MOVE"
        # disable focus switching
        hyprctl keyword input:follow_mouse 3
        hyprctl keyword input:float_switch_override_focus 0
        # Tell Hyprland to switch to submap
        hyprctl dispatch submap move
    else
        # Notify user that the window cannot be moved
        notify-send -r 123 -t 1000 -a "status" "Cannot move" "Only floating windows can be moved"
    fi
}

enable_resize() {
    notify-send -r 123 -t 0 -a "status" "Active submap" "RESIZE"
    hyprctl dispatch submap resize
}

disable_submap() {
    # Hide notification
    
    notify-send -r 123 -t 1 -a "status" "Active submap" "$2"
    # Reenable window focusing
    hyprctl keyword input:follow_mouse 1
    hyprctl keyword input:float_switch_override_focus 1
    # Disable submap
    hyprctl dispatch submap reset
}

if [[ "$1" == "--move_window" ]]; then
    enable_move
elif [[ "$1" == "--disable_move" ]]; then
    disable_submap MOVE
elif [[ "$1" == "--resize_window" ]]; then
    enable_resize
elif [[ "$1" == "--disable_resize" ]]; then
    disable_submap RESIZE
fi

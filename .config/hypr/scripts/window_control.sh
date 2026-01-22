#!/usr/bin/env bash

enable_move() {
    # Get info about the currently focused window
    focused_window=$(hyprctl activewindow -j)

    # Check if it is floating
    is_floating=$(echo "$focused_window" | jq -r '.floating')


    if [ "$is_floating" = "true" ]; then
        # Notify user
        notify-send -r 123 -t 0 -a "status" -i ~/.config/dunst/icons/status_icon.png "Active submap" "MOVE"
        # disable focus switching
        hyprctl keyword input:follow_mouse 3
        hyprctl keyword input:float_switch_override_focus 0
        # Tell Hyprland to switch to submap
        hyprctl dispatch submap move
    else
        # Notify user that the window cannot be moved
        notify-send -r 123 -t 1000 -a "status" -i ~/.config/dunst/icons/status_icon.png "Cannot move" "Only floating windows can be moved"
    fi
}

enable_resize() {
    # Get info about active window
    focused_window=$(hyprctl activewindow -j)

    # Check if wingow is floating
    is_floating=$(echo "$focused_window" | jq -r '.floating')

    # If window is tiled, check if there are other filed windows
    workspace=$(echo "$focused_window" | jq -r '.workspace.id')
    address=$(echo "$focused_window" | jq -r '.address')
    tiled_count=$(hyprctl -j clients | jq --argjson ws "$workspace" 'map(select(.workspace.id == $ws and .floating == false)) | length')
    
    if [ "$tiled_count" -gt 1 ] || [ "$is_floating" = "true" ]; then
        # Notify user
        notify-send -r 123 -t 0 -a "status" -i ~/.config/dunst/icons/status_icon.png "Active submap" "RESIZE"
        # disable focus switching
        hyprctl keyword input:follow_mouse 3
        hyprctl keyword input:float_switch_override_focus 0
        # Tell Hyprland to switch to submap
        hyprctl dispatch submap resize
    else
        notify-send -r 123 -t 1000 -a "status" -i ~/.config/dunst/icons/status_icon.png "Cannot resize" "Lone tiled window cannot be resized"

    fi
}

disable_submap() {
    # Hide notification
    
    notify-send -r 123 -t 1 -a "status" -i ~/.config/dunst/icons/status_icon.png "Active submap" "$2"
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

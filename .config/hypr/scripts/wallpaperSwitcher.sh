#!/usr/bin/env bash

ROOT="$HOME/Pictures/wallpapers"

mapfile -t ALL_WALLPAPERS < <(find "$ROOT" -type f)

while true; do
    # Pick a wallpaper uniformly from all images
    selected="${ALL_WALLPAPERS[RANDOM % ${#ALL_WALLPAPERS[@]}]}"

    category="$(dirname "$selected")"

    mapfile -t CATEGORY_WALLPAPERS < <(
        find "$category" -maxdepth 1 -type f | shuf
    )

    mapfile -t MONITORS < <(
        hyprctl monitors -j | jq -r '.[].name'
    )

    for i in "${!MONITORS[@]}"; do
        if (( i < ${#CATEGORY_WALLPAPERS[@]} )); then
            wallpaper="${CATEGORY_WALLPAPERS[$i]}"
        else
            wallpaper="${CATEGORY_WALLPAPERS[RANDOM % ${#CATEGORY_WALLPAPERS[@]}]}"
        fi

        echo "$(date) ${MONITORS[$i]} -> $wallpaper"

        awww img "$wallpaper" \
            --outputs "${MONITORS[$i]}" \
            --filter Nearest \
            --transition-type fade \
            --transition-duration 2
    done

    sleep 300
done

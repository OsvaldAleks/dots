#!/usr/bin/env bash

get_temp() {
    echo $(~/.config/waybar/scripts/gammaRelayWrapper.sh --check  | jq -r '.percentage')
}

set_temp() {
    current=$(get_temp)
    target=$1

    current=$(( 5600 + (2500 - 5600) * current / 100 ))
    target=$(( 5600 + (2500 - 5600) * target / 100 ))

    diff=$(( target - current ))

    if [[ $diff -le 0 ]]; then
        busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n $diff
    else
        busctl --user call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n $diff
    fi
    pkill -SIGRTMIN+15 waybar
}

get_bright() {
    current=$(brightnessctl g)
    max=$(brightnessctl m)
    echo $(( 100 * current / max ))
}

get_vol() {
    vol=$(wpctl get-volume @DEFAULT_SINK@ | awk '{print $2}')
    percent=$(awk "BEGIN {printf \"%d\", $vol*100}")
    echo $percent
}

set_vol() {
    vol=$(awk "BEGIN {printf \"%.2f\", $1/100}")
    wpctl set-volume @DEFAULT_SINK@ $vol
}

get_vol_mute() {
    if wpctl get-volume @DEFAULT_SINK@ | grep -q "\[MUTED\]"; then
        echo true
    else
        echo false
    fi
}

get_mic_mute() {
    if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "\[MUTED\]"; then
        echo true
    else
        echo false
    fi
}

toggle_mic_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
}

get_mic_vol() {
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2}')
    percent=$(awk "BEGIN {printf \"%d\", $vol*100}")
    echo $percent
}

set_mic_vol() {
    vol=$(awk "BEGIN {printf \"%.2f\", $1/100}")
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ $vol
}

if [[ "$1" == "--get-temp" ]]; then
    get_temp
elif [[ "$1" == "--set-temp" ]]; then
    set_temp $2
elif [[ "$1" == "--get-bright" ]]; then
    get_bright
elif [[ "$1" == "--set-bright" ]]; then
    brightnessctl set $2%
elif [[ "$1" == "--get-vol" ]]; then
    get_vol
elif [[ "$1" == "--set-vol" ]]; then
    set_vol $2
elif [[ "$1" == "--get-vol-mute" ]]; then
    get_vol_mute
elif [[ "$1" == "--toggle-vol-mute" ]]; then
    wpctl set-mute @DEFAULT_SINK@ toggle
elif [[ "$1" == "--get-mic-mute" ]]; then
    get_mic_mute
elif [[ "$1" == "--toggle-mic-mute" ]]; then
    toggle_mic_mute
elif [[ "$1" == "--get-mic-vol" ]]; then
    get_mic_vol
elif [[ "$1" == "--set-mic-vol" ]]; then
    set_mic_vol $2
fi

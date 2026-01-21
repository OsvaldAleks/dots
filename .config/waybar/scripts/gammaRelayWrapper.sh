#!/usr/bin/env bash

MAX_TEMP=5600
MIN_TEMP=2500

get_temp() {
    busctl --user get-property rs.wl-gammarelay / rs.wl.gammarelay Temperature | awk '{print $2}'
}

get_percentage() {
    current=$(get_temp)
    
    # Linear scale: MIN_TEMP → 100%, MAX_TEMP → 0%
    percent=$(( ( (MAX_TEMP - current) * 100 ) / (MAX_TEMP - MIN_TEMP) ))

    # Clamp to 0–100
    if (( percent < 0 )); then
        percent=0
    elif (( percent > 100 )); then
        percent=100
    fi

    # Output JSON
    echo '{"text": "'$percent'%", "percentage": '$percent'}'
}

increase() {
    current=$(get_temp)
    if (( current + 31 > MAX_TEMP )); then
        diff=$(( MAX_TEMP - current ))
        [[ $diff -le 0 ]] && return
    else
        diff=31
    fi
    busctl --user call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n $diff
    pkill -RTMIN+98 waybar
}

decrease() {
    current=$(get_temp)
    if (( current - 31 < MIN_TEMP )); then
        diff=$(( MIN_TEMP - current ))
        [[ $diff -ge 0 ]] && return
    else
        diff=-31
    fi
    busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n $diff
    pkill -RTMIN+98 waybar
}


if [[ "$1" == "--check" ]]; then
    get_percentage
elif [[ "$1" == "--up" ]]; then
    increase
elif [[ "$1" == "--down" ]]; then
    decrease
fi
#!/bin/bash
HISTORY="$(dunstctl count | grep History | awk '{print $2}')"
WAITING="$(dunstctl count | grep Waiting | awk '{print $2}')"
CURRENT="$(dunstctl count | grep 'Currently displayed' | awk '{print $3}')"

HISTORY=${HISTORY:-0}
WAITING=${WAITING:-0}
CURRENT=${CURRENT:-0}

SUM=$(( HISTORY + WAITING + CURRENT ))

if (( SUM > 0 )); then
    echo '{"text": "", "tooltip": "'$SUM' notifications", "class": "nonempty", "percentage": 100 }'
else
    echo '{ "text": "", "tooltip": "No notifications", "class": "empty", "percentage": 0 }'
fi
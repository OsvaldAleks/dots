#!/bin/bash
python $HOME/.config/eww/scripts/renderNotifications.py &

pkill -SIGRTMIN+1 waybar &

#paplay Apps/utils/notification.mp3

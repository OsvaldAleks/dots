#!/bin/bash
 $HOME/.config/eww/scripts/renderNotifications.sh &

pkill -SIGRTMIN+1 waybar &

#paplay Apps/utils/notification.mp3

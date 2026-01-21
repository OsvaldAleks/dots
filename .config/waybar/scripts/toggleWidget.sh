#!/bin/bash

reset_dropdowns(){
    if [ $CURRENT != *"settings" ]; then
        $EWW_DIR update showPowerMenu=false
        $EWW_DIR update showBluetoothMenu=false
        $EWW_DIR update showBatteryMenu=false
    fi 
}
update_media(){
    if [ "$1" == "media" ]; then
       "$HOME/.config/eww/scripts/musicInfo.sh" --cover --force
    fi
}
render_notifications(){
    if [ "$1" == "notifications" ]; then
        python $HOME/.config/eww/scripts/renderNotifications.py &
    fi
}

# Define the path to the Eww executable
EWW_DIR="$HOME/Apps/eww/target/release/eww"

# Check if a widget name was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <widget-name>"
    exit 1
fi
WIDGET="$1"

# get current open window
CURRENT_WINDOW=$($EWW_DIR active-windows)
CURRENT="${CURRENT_WINDOW%%:*}"

# Check if the widget is already open
if [[ $CURRENT == *"$WIDGET" ]]; then
    # Close the widget
    $EWW_DIR close "$WIDGET"
    #reset_dropdowns
else
    # Open the widget
    if [[ $CURRENT != "" ]]; then
        $EWW_DIR close "$CURRENT"
        #reset_dropdowns
    fi
    $EWW_DIR open "$WIDGET"
    update_media $WIDGET
    render_notifications $WIDGET

fi

echo "toggeled $WIDGET"
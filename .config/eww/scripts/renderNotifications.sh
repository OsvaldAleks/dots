#!/bin/bash

EWW_DIR="$HOME/Apps/eww/target/release/eww"

generateNotificationYuck() {
  raw_json=$(dunstctl history --json)
  mapfile -t notifications < <(echo "$raw_json" | jq -c '.data[0][]')

  if [ ${#notifications[@]} -eq 0 ]; then
    # no notifications
    yuck_output="(box :class 'empty' :orientation 'v' :vexpand true :space-evenly false :valign 'center' (label :class 'icon' :text '')(label :text 'No notifications'))"
  else
    yuck_output="(box :orientation \"v\" :space-evenly false"

        for notif in "${notifications[@]}"; do
            appname=$(echo "$notif" | jq -r '.appname.data')
            title=$(echo "$notif" | jq -r '.summary.data')
            body=$(echo "$notif" | jq -r '.body.data')
            icon=$(echo "$notif" | jq -r '.icon_path.data')
            id=$(echo "$notif" | jq -r '.id.data')

            if [[ -z "$icon" || "$icon" == "null" ]]; then
                icon_box=""
            else
                icon_box="(box :class \"icon\" :style \"background-image: url('$icon');\")"
            fi

            yuck_output+="
            (button :class \"notification\" :onclick \"scripts/renderNotifications.sh --remove-entry $id\"
                (box :orientation \"h\" :height 100 :space-evenly false
                    $icon_box
                    (box :orientation \"v\" :space-evenly false :valign \"center\"
                        (box :orientation \"h\" :space-evenly false :halign \"start\" (label :class \"line1\" :limit-width 50 :lines 1 :text \"$appname\"))
                        (box :orientation \"h\" :space-evenly false :halign \"start\" (label :class \"line2\" :limit-width 50:lines 1 :text \"$title\"))
                        (box :orientation \"h\" :space-evenly false :halign \"start\" (label :class \"line3\" :limit-width 50 :lines 1 :text \"$body\"))
                    )
                )
            )"
        done

        yuck_output+=")"
    fi
    # Escape the entire Yuck block for Eww update
    $EWW_DIR update notificationLiteral="$yuck_output"
}

removeEntry() {
    local id="$1"
    # repeat until no entries with this ID remain
    while dunstctl history --json | jq -e ".data[0][] | select(.id.data == $id)" >/dev/null; do
        dunstctl history-rm "$id"
        "$HOME/.config/waybar/scripts/processNotification.sh"
    done
}

if [[ "$1" == "--remove-entry" ]]; then
    removeEntry "$2"
else
    generateNotificationYuck
fi

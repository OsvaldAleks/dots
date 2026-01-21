import subprocess
import json
import os
import re

def clean_text(text: str) -> str:
    if not text:
        return ""

    text = re.sub(r"<.*?>", "", text)
    text = text.replace('"', '\\"')

    lines = [l.strip() for l in text.splitlines() if l.strip()]

    content = lines[2:] if len(lines) > 2 else []

    if len(content) > 1:
        hidden = len(content) - 1
        text = f"{hidden}^ ...\n{content[-1]}"
    elif content:
        text = content[-1]
    else:
        text = lines[-1] if lines else ""

    return text



eww_path = os.path.expanduser("~/Apps/eww/target/release/eww")

template = """(button :class "notification" :onclick "scripts/renderNotifications.sh --remove-entry {id}"
                        (box :orientation "h" :height 100 :space-evenly false
                            {icon_box}
                            (box :orientation "v" :space-evenly false :valign "center"
                                (box :orientation "h" :space-evenly false :halign "start"
                                    (label :class "line1" :limit-width 28 :lines 1 :text "{appname}"))
                                (box :orientation "h" :space-evenly false :halign "start"
                                    (label :class "line2" :limit-width 28 :lines 1 :text "{title}"))
                                (box :orientation "h" :space-evenly false :halign "start"
                                    (label :class "line3" :limit-width 50 :lines 1 :text "{body}"))
                            )
                        )
                    )"""

yuck = '(box :orientation "v" :space-evenly false {listOfItems})'

# grab notification history
notificationHistoryJSON = json.loads(
    subprocess.check_output(
        "dunstctl history --json", shell=True, executable="/bin/bash"
    )
)["data"][0]

notifications_by_id = {}

for notification in notificationHistoryJSON:
    nid = notification["id"]["data"]
    ts = notification["timestamp"]["data"]

    icon_path = notification["icon_path"]["data"] 
    if icon_path:
        print(icon_path)
        icon_box = f'(box :class "icon" :style "background-image: url(\'{icon_path}\');")'
    else:
        icon_box = '(box)' 

    candidate = {
        "id": nid,
        "appname": clean_text(notification["appname"]["data"]),
        "title": clean_text(notification["summary"]["data"]),
        "body": clean_text(notification["message"]["data"]),
        "icon_box": icon_box,
        "timestamp": ts,
    }

    if nid in notifications_by_id:
        if ts > notifications_by_id[nid]["timestamp"]:
            notifications_by_id[nid] = candidate
    else:
        notifications_by_id[nid] = candidate

# Now build render list
toRender = sorted(
    notifications_by_id.values(),
    key=lambda n: n["timestamp"],
    reverse=True
)

if not toRender:
    yuck = """(box :class "empty" :orientation "v" :vexpand true :space-evenly false :valign "center"
                (label :class "icon" :text "")
                (label :text "No notifications"))"""
else:
    renderedItems = [template.format(**item) for item in toRender]
    yuck = yuck.format(listOfItems=" ".join(renderedItems))

# push into eww
subprocess.run([eww_path, "update", f"notificationLiteral={yuck}"])
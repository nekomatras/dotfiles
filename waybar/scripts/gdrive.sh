#!/usr/bin/env bash

USERFLAG="--user"
SERVICE="rclone-remote.service"

# get cords
POS=$(hyprctl cursorpos)

# split by ,
IFS=',' read -r X Y <<< "$POS"

# remove spaces
X=$(echo "$X" | xargs)
Y=$(echo "$Y" | xargs)
X=$((X + 0))
Y=$((Y + 0))

# get menu
CHOICE=$(echo -e "Start\nStop\nRestart\nReLogin\nCancel" | \
    wofi --dmenu --cache-file="/dev/null" --hide-search --lines 5 \
    --x $X --y $Y --width 200 --height 120)

# do smth
case "$CHOICE" in
    "Start")
        systemctl "$USERFLAG" start "$SERVICE"
        ;;
    "Stop")
        systemctl "$USERFLAG" stop "$SERVICE"
        ;;
    "Restart")
        systemctl "$USERFLAG" restart "$SERVICE"
        ;;
    "ReLogin")
        yes "" | rclone config reconnect gdrive:
	systemctl "$USERFLAG" restart "$SERVICE"
        ;;
    *)
        ;;
esac

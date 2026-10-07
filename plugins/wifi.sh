#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

SSID=$(networksetup -getairportnetwork en0 2>/dev/null | sed 's/Current Wi-Fi Network: //')

if [ -z "$SSID" ] || [ "$SSID" = "" ]; then
  sketchybar --set $NAME icon=$ICON_WIFI_OFF icon.color=$RED label="Off"
else
  sketchybar --set $NAME icon=$ICON_WIFI icon.color=$TEAL label="$SSID"
fi

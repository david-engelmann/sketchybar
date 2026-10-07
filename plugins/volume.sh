#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
else
  VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi

if [ "$VOLUME" -eq 0 ] 2>/dev/null; then
  ICON=$ICON_VOLUME_MUTE
  COLOR=$RED
elif [ "$VOLUME" -lt 30 ] 2>/dev/null; then
  ICON=$ICON_VOLUME_LOW
  COLOR=$SUBTEXT0
else
  ICON=$ICON_VOLUME
  COLOR=$LAVENDER
fi

sketchybar --set $NAME icon="$ICON" icon.color=$COLOR label="${VOLUME}%"

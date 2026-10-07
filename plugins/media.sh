#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

STATE=$(nowplaying-cli get playbackRate 2>/dev/null)
PLAYER=$(nowplaying-cli get clientPropertiesBundleIdentifier 2>/dev/null)

if [ -z "$STATE" ] || [ "$STATE" = "null" ]; then
  sketchybar --set $NAME label="Not Playing" icon.color=$OVERLAY0
  exit 0
fi

TITLE=$(nowplaying-cli get title 2>/dev/null | sed 's/null//g')
ARTIST=$(nowplaying-cli get artist 2>/dev/null | sed 's/null//g')

if [ -z "$TITLE" ]; then
  sketchybar --set $NAME label="Not Playing" icon.color=$OVERLAY0
  exit 0
fi

# Choose icon based on player and state
if [[ "$PLAYER" == *"spotify"* ]]; then
  ICON=$ICON_SPOTIFY
  ICON_COLOR=$GREEN
elif [[ "$STATE" == "0" ]] || [[ "$STATE" == "0.0" ]]; then
  ICON=$ICON_MEDIA_PAUSE
  ICON_COLOR=$SUBTEXT0
else
  ICON=$ICON_MEDIA_PLAY
  ICON_COLOR=$MAUVE
fi

if [ -n "$ARTIST" ]; then
  DISPLAY="$ARTIST - $TITLE"
else
  DISPLAY="$TITLE"
fi

sketchybar --set $NAME label="$DISPLAY" icon="$ICON" icon.color=$ICON_COLOR

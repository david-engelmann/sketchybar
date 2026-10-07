#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME \
    background.color=$ACTIVE_BG \
    background.border_width=2 \
    background.border_color=$LAVENDER \
    icon.color=0xff1e1e2e \
    label.shadow.drawing=on \
    icon.shadow.drawing=on
else
  sketchybar --set $NAME \
    background.color=$ITEM_BG \
    background.border_width=0 \
    icon.color=$TEXT \
    label.shadow.drawing=off \
    icon.shadow.drawing=off
fi

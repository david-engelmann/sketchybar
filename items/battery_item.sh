#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --add item battery right \
  --set battery \
  icon=$ICON_BATTERY_100 \
  icon.font="Hack Nerd Font:Bold:16.0" \
  icon.color=$GREEN \
  icon.padding_left=8 \
  icon.padding_right=4 \
  label.font="SF Pro:Semibold:12.0" \
  label.color=$TEXT \
  label.padding_right=8 \
  background.color=$SURFACE0 \
  background.corner_radius=8 \
  background.height=26 \
  background.drawing=on \
  update_freq=120 \
  script="$PLUGIN_DIR/battery.sh" \
  --subscribe battery system_woke power_source_change

#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --add item front_app left \
  --set front_app \
  icon.drawing=on \
  icon.background.drawing=on \
  icon.background.image.scale=0.7 \
  icon.background.image.corner_radius=4 \
  icon.padding_left=4 \
  icon.padding_right=0 \
  label.font="SF Pro:Semibold:13.0" \
  label.color=$TEXT \
  label.padding_left=6 \
  label.padding_right=8 \
  background.color=$SURFACE0 \
  background.corner_radius=8 \
  background.height=26 \
  background.drawing=on \
  background.padding_left=4 \
  display=active \
  script="$PLUGIN_DIR/front_app.sh" \
  click_script="open -a 'Mission Control'" \
  --subscribe front_app front_app_switched

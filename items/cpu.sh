#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --add item cpu right \
  --set cpu \
  icon=$ICON_CPU \
  icon.font="Hack Nerd Font:Bold:16.0" \
  icon.color=$SAPPHIRE \
  icon.padding_left=8 \
  icon.padding_right=4 \
  label="0%" \
  label.font="SF Pro:Semibold:12.0" \
  label.color=$TEXT \
  label.padding_right=8 \
  background.color=$SURFACE0 \
  background.corner_radius=8 \
  background.height=26 \
  background.drawing=on \
  update_freq=3 \
  script="$PLUGIN_DIR/cpu.sh"

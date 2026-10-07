#!/bin/bash

# AeroSpace binding-mode badge — hidden in main mode, shown (e.g. SERVICE)
# otherwise. Updated by aerospace's on-mode-changed → plugins/aerospace_mode.sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add item aerospace_mode left \
  --set aerospace_mode \
  drawing=off \
  icon.drawing=off \
  label.font="Hack Nerd Font:Bold:12.0" \
  label.color=$BASE \
  label.padding_left=8 \
  label.padding_right=8 \
  background.color=$PEACH \
  background.corner_radius=5 \
  background.height=22 \
  background.drawing=on \
  display=active

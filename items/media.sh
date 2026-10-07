#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

sketchybar --add item media center \
  --set media \
  icon=$ICON_MUSIC \
  icon.font="Hack Nerd Font:Bold:16.0" \
  icon.color=$MAUVE \
  icon.padding_left=8 \
  icon.padding_right=4 \
  label="Not Playing" \
  label.font="SF Pro:Semibold:12.0" \
  label.color=$SUBTEXT0 \
  label.padding_right=8 \
  label.max_chars=40 \
  background.color=$SURFACE0 \
  background.corner_radius=8 \
  background.height=26 \
  background.drawing=on \
  update_freq=3 \
  script="$PLUGIN_DIR/media.sh" \
  click_script="nowplaying-cli togglePlayPause" \
  --subscribe media media_change

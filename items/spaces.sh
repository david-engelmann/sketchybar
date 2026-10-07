#!/bin/bash

source "$CONFIG_DIR/colors.sh"

sketchybar --add event aerospace_workspace_change

# aerospace with a hard timeout — at login the server may not be up yet
# (aerospace's after-startup-command reloads the bar once it is)
aero() { perl -e 'alarm shift; exec @ARGV' 3 aerospace "$@"; }

# Each aerospace monitor maps to the sketchybar display with the same NSScreen
# index, so workspace items always land on the bar of the monitor they live on.
# (sketchybarrc runs under /bin/sh, so no bash-only `< <(...)` here.)
while read -r monitor_id display_id; do
  for sid in $(aero list-workspaces --monitor "$monitor_id"); do
    sketchybar --add item space.$sid left \
      --set space.$sid \
      display="$display_id" \
      drawing=on \
      background.color=$ITEM_BG \
      background.corner_radius=5 \
      background.drawing=on \
      background.border_color=$LAVENDER \
      background.border_width=0 \
      background.height=25 \
      icon="$sid" \
      icon.font="Hack Nerd Font:Bold:14.0" \
      icon.color=$TEXT \
      icon.padding_left=8 \
      icon.padding_right=2 \
      icon.shadow.distance=3 \
      icon.shadow.color=$SHADOW \
      label.font="sketchybar-app-font:Regular:14.0" \
      label.padding_right=12 \
      label.padding_left=0 \
      label.y_offset=-1 \
      label.color=$TEXT \
      click_script="aerospace workspace $sid" \
      script="$CONFIG_DIR/plugins/aerospace.sh $sid" \
      --subscribe space.$sid aerospace_workspace_change
  done
done <<EOF
$(aero list-monitors --format '%{monitor-id} %{monitor-appkit-nsscreen-screens-id}')
EOF

# Highlight the focused workspace and load app icons
focused=$(aero list-workspaces --focused)
[ -n "$focused" ] && sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$focused"
"$CONFIG_DIR/plugins/update_workspace_icon.sh" &

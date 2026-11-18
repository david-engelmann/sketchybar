#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# One pill per AeroSpace workspace, created hidden. plugins/workspaces.sh decides
# which display each sits on, whether it shows (only workspaces with windows),
# its app icons and its highlight — so the same bar works on the laptop alone
# and with the office monitors, and re-arranges itself when you dock/undock.
# No aerospace calls here: the bar builds instantly even if AeroSpace isn't up.
for sid in A B C D E F G J K M N O P Q S T V W; do
  sketchybar --add item space.$sid left \
    --set space.$sid \
    drawing=off \
    background.color=$ITEM_BG \
    background.corner_radius=5 \
    background.drawing=on \
    background.border_color=$LAVENDER \
    background.border_width=0 \
    background.height=25 \
    icon="$sid" \
    icon.font="Hack Nerd Font:Bold:14.0" \
    icon.color=$TEXT \
    icon.padding_left=7 \
    icon.padding_right=2 \
    label.font="sketchybar-app-font:Regular:14.0" \
    label.padding_right=9 \
    label.padding_left=0 \
    label.y_offset=-1 \
    label.color=$TEXT \
    click_script="aerospace workspace $sid"
done

# Shown only when AeroSpace is running but can't see any windows. Usually
# macOS's Accessibility layer broke after a WindowServer hang/restart (fix: log
# out and back in); rarely a stale AeroSpace permission (click: opens the setting).
sketchybar --add item aerospace_health left \
  --set aerospace_health \
  drawing=off \
  icon.drawing=off \
  label="AeroSpace can't see windows - log out and back in" \
  label.font="Hack Nerd Font:Bold:12.0" \
  label.color=$BASE \
  label.padding_left=8 \
  label.padding_right=8 \
  background.color=$RED \
  background.corner_radius=5 \
  background.height=22 \
  background.drawing=on \
  click_script="open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'"

# Invisible item that refreshes the pills when windows open or close,
# displays are plugged or unplugged, or the machine wakes
sketchybar --add item workspaces_watcher left \
  --set workspaces_watcher \
  drawing=off \
  updates=on \
  script="$CONFIG_DIR/plugins/workspaces.sh" \
  --subscribe workspaces_watcher space_windows_change display_change system_woke

"$CONFIG_DIR/plugins/workspaces.sh" &

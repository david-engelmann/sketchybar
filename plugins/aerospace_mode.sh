#!/bin/bash
# Called by aerospace's on-mode-changed. The callback passes no mode variable,
# so ask aerospace for the current mode (with a timeout, like every hook script).

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

mode=$(perl -e 'alarm 3; exec @ARGV' aerospace list-modes --current)

if [ -z "$mode" ] || [ "$mode" = "main" ]; then
  sketchybar --set aerospace_mode drawing=off
else
  sketchybar --set aerospace_mode drawing=on label="$(echo "$mode" | tr '[:lower:]' '[:upper:]')"
fi

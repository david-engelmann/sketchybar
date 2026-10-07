#!/bin/bash

source "$CONFIG_DIR/colors.sh"

CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')
CORES=$(sysctl -n hw.logicalcpu)
PERCENT=$((CPU / CORES))

# Color based on load
if [ "$PERCENT" -gt 80 ]; then
  COLOR=$RED
elif [ "$PERCENT" -gt 50 ]; then
  COLOR=$YELLOW
else
  COLOR=$SAPPHIRE
fi

sketchybar --set $NAME label="${PERCENT}%" icon.color=$COLOR

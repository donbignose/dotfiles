#!/bin/bash
source "$CONFIG_DIR/colors.sh"

COUNT=$(/opt/homebrew/bin/brew outdated 2>/dev/null | wc -l | tr -d ' ')
CASKS=$(/opt/homebrew/bin/brew outdated --cask --greedy 2>/dev/null | wc -l | tr -d ' ')
TOTAL=$((COUNT + CASKS))

if [ "$TOTAL" -gt 0 ]; then
	sketchybar --set "$NAME" icon=󰏗 icon.color="$ACCENT_COLOR" label="$TOTAL" label.drawing=on
else
	sketchybar --set "$NAME" icon=󰏗 icon.color="$MUTED_COLOR" label.drawing=off
fi

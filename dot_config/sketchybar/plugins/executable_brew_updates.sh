#!/bin/bash
source "$CONFIG_DIR/colors.sh"

CACHE="/tmp/sketchybar_brew_count"
ACCENT="$ACCENT_COLOR"
MUTED="$MUTED_COLOR"

# Show cached value immediately
COUNT=$(cat "$CACHE" 2>/dev/null)
COUNT=${COUNT:-0}

if [ "$COUNT" -gt 0 ]; then
	sketchybar --set "$NAME" icon=󰏗 icon.color="$ACCENT" label="$COUNT" label.drawing=on
else
	sketchybar --set "$NAME" icon=󰏗 icon.color="$MUTED" label.drawing=off
fi

# Refresh cache in background (formulae + greedy casks)
(
	FORMULAE=$(/opt/homebrew/bin/brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')
	CASKS=$(/opt/homebrew/bin/brew outdated --cask --greedy --quiet 2>/dev/null | wc -l | tr -d ' ')
	NEW_COUNT=$((FORMULAE + CASKS))
	echo "$NEW_COUNT" > "$CACHE"
	if [ "$NEW_COUNT" -gt 0 ]; then
		sketchybar --set brew_updates icon.color="$ACCENT" label="$NEW_COUNT" label.drawing=on
	else
		sketchybar --set brew_updates icon.color="$MUTED" label.drawing=off
	fi
) &

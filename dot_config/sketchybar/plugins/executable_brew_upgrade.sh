#!/bin/bash
source "$CONFIG_DIR/colors.sh"

ACCENT="$ACCENT_COLOR"
MUTED="$MUTED_COLOR"

# Show updating state
sketchybar --set brew_updates icon=󰏗 icon.color="$ACCENT_YELLOW" label="..." label.drawing=on

# Run upgrade in background, refresh count when done
(
	/opt/homebrew/bin/brew upgrade --quiet 2>/dev/null
	/opt/homebrew/bin/brew upgrade --cask --greedy --quiet 2>/dev/null
	/opt/homebrew/bin/brew cleanup --quiet 2>/dev/null

	FORMULAE=$(/opt/homebrew/bin/brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')
	CASKS=$(/opt/homebrew/bin/brew outdated --cask --greedy --quiet 2>/dev/null | wc -l | tr -d ' ')
	COUNT=$((FORMULAE + CASKS))
	echo "$COUNT" > /tmp/sketchybar_brew_count

	if [ "$COUNT" -gt 0 ]; then
		sketchybar --set brew_updates icon.color="$ACCENT" label="$COUNT" label.drawing=on
	else
		sketchybar --set brew_updates icon.color="$MUTED" label.drawing=off
	fi
) &

#!/bin/bash
source "$CONFIG_DIR/colors.sh"

update() {
	if pgrep -q caffeinate; then
		sketchybar --set "$NAME" icon=󰒳 icon.color="$ACCENT_COLOR"
	else
		sketchybar --set "$NAME" icon=󰒲 icon.color="$MUTED_COLOR"
	fi
}

toggle() {
	if pgrep -q caffeinate; then
		pkill caffeinate
	else
		caffeinate -di &
	fi
	sleep 0.3
	update
}

case "$SENDER" in
	"mouse.clicked") toggle ;;
	*) update ;;
esac

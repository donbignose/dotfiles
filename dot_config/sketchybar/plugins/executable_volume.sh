#!/bin/bash

update_vol() {
	VOL="$1"
	case "$VOL" in
		[7-9][0-9]|100)    ICON="󰕾" ;;
		[3-6][0-9])         ICON="󰖀" ;;
		[1-9]|[1-2][0-9])  ICON="󰕿" ;;
		*)                  ICON="󰝟" ;;
	esac

	MUTED=$(osascript -e 'output muted of (get volume settings)')
	if [ "$MUTED" = "true" ] || [ "$VOL" = "0" ]; then
		sketchybar --set "$NAME" icon="󰝟" label.drawing=off
	else
		sketchybar --set "$NAME" icon="$ICON" label="$VOL%" label.drawing=on
	fi
}

case "$SENDER" in
	"volume_change")
		update_vol "$INFO"
		;;
	"mouse.scrolled")
		VOL=$(osascript -e 'output volume of (get volume settings)')
		NEW=$((VOL + SCROLL_DELTA * 3))
		[ "$NEW" -gt 100 ] && NEW=100
		[ "$NEW" -lt 0 ] && NEW=0
		osascript -e "set volume output volume $NEW"
		update_vol "$NEW"
		;;
esac

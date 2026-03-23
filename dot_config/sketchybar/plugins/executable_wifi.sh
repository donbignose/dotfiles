#!/bin/bash
source "$CONFIG_DIR/colors.sh"

IP=$(ipconfig getifaddr en0 2>/dev/null)

if [ -n "$IP" ]; then
	RSSI=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Signal \/ Noise/ {match($0, /-[0-9]+/); print substr($0, RSTART, RLENGTH); exit}')
	RSSI=${RSSI:-"-100"}

	if [ "$RSSI" -gt -60 ]; then
		ICON="󰤨"
	elif [ "$RSSI" -gt -70 ]; then
		ICON="󰤥"
	elif [ "$RSSI" -gt -80 ]; then
		ICON="󰤢"
	else
		ICON="󰤟"
	fi
	COLOR=$ACCENT_COLOR
else
	ICON="󰤭"
	COLOR=$ACCENT_RED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"

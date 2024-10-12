#!/bin/bash

update() {
	INFO="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}' | xargs networksetup -getairportnetwork | sed "s/Current Wi-Fi Network: //")"
	LABEL="$INFO ($(ipconfig getifaddr en0))"
	ICON="$([ -n "$INFO" ] && echo "􀙇" || echo "􀙈")"
	COLOR="$([ -n "$INFO" ] && echo "$ACCENT_COLOR" || echo "$ACCENT_COLOR")"

	sketchybar --set $NAME icon="$ICON" color=$COLOR label="$LABEL"
}

click() {
	CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"

	WIDTH=0
	if [ "$CURRENT_WIDTH" -eq "0" ]; then
		WIDTH=dynamic
	fi

	sketchybar --animate sin 20 --set $NAME label.width="$WIDTH"
}

case "$SENDER" in
"wifi_change")
	update
	;;
"mouse.clicked")
	click
	;;
esac

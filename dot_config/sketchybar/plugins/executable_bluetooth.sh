#!/bin/bash
source "$CONFIG_DIR/colors.sh"

ICON_MOUSE="󰍽"
ICON_KEYBOARD="󰌌"
ICON_HEADSET="󰋋"
ICON_PHONE="󰏲"
ICON_OTHER="󰂯"

device_icon() {
	case "$1" in
		*[Mm]ouse*|*MX*) echo "$ICON_MOUSE" ;;
		*[Kk]eyboard*|*Keys*|*MCHNCL*) echo "$ICON_KEYBOARD" ;;
		*[Hh]eadset*|*[Hh]eadphone*|*[Bb]ud*|*soundcore*|*AirPod*) echo "$ICON_HEADSET" ;;
		*iPhone*|*Phone*) echo "$ICON_PHONE" ;;
		*) echo "$ICON_OTHER" ;;
	esac
}

update() {
	BT_STATE=$(system_profiler SPBluetoothDataType 2>/dev/null | awk '/State:/ {print $2; exit}')

	if [ "$BT_STATE" = "On" ]; then
		CONNECTED=$(blueutil --paired --format json 2>/dev/null | python3 -c "
import sys, json
devices = json.load(sys.stdin)
connected = [d['name'] for d in devices if d['connected']]
print(len(connected))
" 2>/dev/null)
		CONNECTED=${CONNECTED:-0}

		if [ "$CONNECTED" -gt 0 ]; then
			ICON="󰂱"
		else
			ICON="󰂯"
		fi
		COLOR=$ACCENT_COLOR
	else
		ICON="󰂲"
		COLOR=$MUTED_COLOR
	fi

	sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label.drawing=off
}

show_popup() {
	# Remove old popup items
	OLD=$(sketchybar --query bluetooth | jq -r '.popup.items[]' 2>/dev/null | grep "bluetooth.device")
	for item in $OLD; do
		sketchybar --remove "$item" 2>/dev/null
	done

	DEVICES=$(blueutil --paired --format json 2>/dev/null | python3 -c "
import sys, json
devices = json.load(sys.stdin)
for d in devices:
    status = 'connected' if d['connected'] else 'disconnected'
    print(f'{d[\"name\"]}|{d[\"address\"]}|{status}')
" 2>/dev/null)

	INDEX=0
	while IFS='|' read -r DNAME ADDR STATUS; do
		[ -z "$DNAME" ] && continue

		DICON=$(device_icon "$DNAME")

		if [ "$STATUS" = "connected" ]; then
			COLOR=$ACCENT_GREEN
			ACTION="sketchybar --set bluetooth.device.$INDEX icon=󰑐 icon.color=$ACCENT_YELLOW label='Disconnecting...'; blueutil --disconnect $ADDR; sketchybar --set bluetooth popup.drawing=off; sketchybar --trigger bluetooth_update"
		else
			COLOR=$MUTED_COLOR
			ACTION="sketchybar --set bluetooth.device.$INDEX icon=󰑐 icon.color=$ACCENT_YELLOW label='Connecting...'; blueutil --connect $ADDR; sketchybar --set bluetooth popup.drawing=off; sketchybar --trigger bluetooth_update"
		fi

		sketchybar \
			--add item "bluetooth.device.$INDEX" popup.bluetooth \
			--set "bluetooth.device.$INDEX" \
			icon="$DICON" \
			icon.color="$COLOR" \
			icon.font="SF Pro:Semibold:17.0" \
			icon.padding_left=10 \
			label="$DNAME" \
			label.font="SF Pro:Medium:13.0" \
			label.color="$ACCENT_COLOR" \
			label.padding_right=10 \
			background.drawing=off \
			click_script="$ACTION"

		INDEX=$((INDEX + 1))
	done <<< "$DEVICES"
}

case "$SENDER" in
	"mouse.clicked")
		DRAWING=$(sketchybar --query "$NAME" | jq -r '.popup.drawing')
		if [ "$DRAWING" = "on" ]; then
			sketchybar --set "$NAME" popup.drawing=off
		else
			show_popup
			sketchybar --set "$NAME" popup.drawing=on
		fi
		;;
	"mouse.exited.global")
		sketchybar --set "$NAME" popup.drawing=off
		;;
	*)
		update
		;;
esac

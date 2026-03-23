#!/bin/bash
source "$CONFIG_DIR/colors.sh"

update() {
	PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
	CHARGING="$(pmset -g batt | grep 'AC Power')"

	if [ -z "$PERCENTAGE" ]; then
		exit 0
	fi

	case "${PERCENTAGE}" in
		9[0-9]|100) ICON="󰁹" ;;
		[7-8][0-9])  ICON="󰂁" ;;
		[5-6][0-9])  ICON="󰁿" ;;
		[3-4][0-9])  ICON="󰁽" ;;
		[1-2][0-9])  ICON="󰁻" ; COLOR=$ACCENT_YELLOW ;;
		*)           ICON="󰁺" ; COLOR=$ACCENT_RED ;;
	esac

	if [ -n "$CHARGING" ]; then
		ICON="󰂄"
		COLOR=$ACCENT_GREEN
	fi

	sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="${COLOR:-$ACCENT_COLOR}"
}

update_popup() {
	TIME_LEFT=$(pmset -g batt | grep -Eo "([0-9]+:[0-9]+)" | head -1)
	CHARGING="$(pmset -g batt | grep 'AC Power')"
	LPM=$(pmset -g | awk '/lowpowermode/ {print $2}')

	CHARGED=$(pmset -g batt | grep -c 'charged')

	if [ "$CHARGED" -gt 0 ]; then
		TIME_LABEL="Fully charged"
	elif [ -n "$CHARGING" ] && [ -n "$TIME_LEFT" ]; then
		TIME_LABEL="${TIME_LEFT} until full"
	elif [ -n "$TIME_LEFT" ]; then
		TIME_LABEL="${TIME_LEFT} remaining"
	elif [ -n "$CHARGING" ]; then
		TIME_LABEL="Charging..."
	else
		TIME_LABEL="Calculating..."
	fi

	if [ "$LPM" = "1" ]; then
		LPM_ICON="󰄬"
		LPM_COLOR=$ACCENT_GREEN
	else
		LPM_ICON="󱈏"
		LPM_COLOR=$ACCENT_YELLOW
	fi

	sketchybar \
		--set battery.time label="$TIME_LABEL" \
		--set battery.lowpower icon="$LPM_ICON" icon.color="$LPM_COLOR"
}

case "$SENDER" in
	"mouse.clicked")
		update_popup
		sketchybar --set "$NAME" popup.drawing=toggle
		;;
	"mouse.exited.global")
		sketchybar --set "$NAME" popup.drawing=off
		;;
	*)
		update
		;;
esac

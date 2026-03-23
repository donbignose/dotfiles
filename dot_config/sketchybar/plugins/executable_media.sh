#!/bin/bash

update_from_event() {
	STATE="$(echo "$INFO" | jq -r '.state')"
	MEDIA="$(echo "$INFO" | jq -r '.title + " – " + .artist')"

	if [ "$STATE" = "playing" ]; then
		sketchybar --set "$NAME" label="$MEDIA" icon=󰏤 drawing=on
	elif [ "$STATE" = "paused" ]; then
		sketchybar --set "$NAME" label="$MEDIA" icon=󰐊 drawing=on
	else
		sketchybar --set "$NAME" drawing=off
	fi
}

update_from_poll() {
	for APP in Spotify Music; do
		if ! pgrep -q "$APP"; then
			continue
		fi

		STATE=$(osascript -e "tell application \"$APP\" to player state as string" 2>/dev/null)
		if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
			TITLE=$(osascript -e "tell application \"$APP\" to name of current track" 2>/dev/null)
			ARTIST=$(osascript -e "tell application \"$APP\" to artist of current track" 2>/dev/null)
			ICON=$( [ "$STATE" = "playing" ] && echo "󰏤" || echo "󰐊" )
			sketchybar --set "$NAME" label="$TITLE – $ARTIST" icon="$ICON" drawing=on
			return
		fi
	done

	sketchybar --set "$NAME" drawing=off
}

case "$SENDER" in
	"media_change")
		update_from_event
		;;
	"mouse.scrolled")
		if [ "$SCROLL_DELTA" -gt 0 ]; then
			osascript -e 'tell application "Spotify" to next track' 2>/dev/null || \
			osascript -e 'tell application "Music" to next track' 2>/dev/null
		else
			osascript -e 'tell application "Spotify" to previous track' 2>/dev/null || \
			osascript -e 'tell application "Music" to previous track' 2>/dev/null
		fi
		sleep 0.5
		update_from_poll
		;;
	*)
		update_from_poll
		;;
esac

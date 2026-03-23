#!/bin/bash

# Toggle play/pause
if pgrep -q Spotify; then
	osascript -e 'tell application "Spotify" to playpause'
	sleep 0.3
	STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
elif pgrep -q Music; then
	osascript -e 'tell application "Music" to playpause'
	sleep 0.3
	STATE=$(osascript -e 'tell application "Music" to player state as string' 2>/dev/null)
fi

if [ "$STATE" = "playing" ]; then
	sketchybar --set media icon=󰏤
else
	sketchybar --set media icon=󰐊
fi

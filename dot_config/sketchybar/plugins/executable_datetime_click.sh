#!/bin/bash

CURRENT_ICON=$(sketchybar --query datetime | jq -r '.icon.value')

if [ "$CURRENT_ICON" = "󰥔" ]; then
	sketchybar --set datetime icon=󰃭 label="$(date '+%a %d %b')"
else
	sketchybar --set datetime icon=󰥔 label="$(date '+%H:%M')"
fi

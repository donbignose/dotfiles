#!/bin/bash
source "$CONFIG_DIR/colors.sh"

LPM=$(pmset -g | awk '/lowpowermode/ {print $2}')

if [ "$LPM" = "1" ]; then
	sudo pmset -a lowpowermode 0
	sketchybar --set battery.lowpower icon="󱈏" icon.color="$ACCENT_YELLOW"
else
	sudo pmset -a lowpowermode 1
	sketchybar --set battery.lowpower icon="󰄬" icon.color="$ACCENT_GREEN"
fi

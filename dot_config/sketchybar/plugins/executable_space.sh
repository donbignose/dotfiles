#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ $SELECTED = true ]; then
	sketchybar --set $NAME background.drawing=on \
		background.color=$ACCENT_COLOR \
		label.color=$BAR_COLOR \
		icon.color=$BAR_COLOR
else
	sketchybar --set $NAME background.drawing=off \
		label.color=$FG_DIM \
		icon.color=$FG_DIM
fi

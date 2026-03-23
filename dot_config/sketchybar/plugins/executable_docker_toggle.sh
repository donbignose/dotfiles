#!/bin/bash
source "$CONFIG_DIR/colors.sh"

PROJECT="$1"

FIRST_CHILD="docker.child.${PROJECT}.0"
VISIBLE=$(sketchybar --query "$FIRST_CHILD" 2>/dev/null | jq -r '.geometry.drawing' 2>/dev/null)

if [ "$VISIBLE" = "on" ]; then
	IDX=0
	while sketchybar --query "docker.child.${PROJECT}.${IDX}" &>/dev/null; do
		sketchybar --set "docker.child.${PROJECT}.${IDX}" drawing=off
		IDX=$((IDX + 1))
	done
	sketchybar --set "docker.group.${PROJECT}" icon=󰅂
else
	IDX=0
	while sketchybar --query "docker.child.${PROJECT}.${IDX}" &>/dev/null; do
		sketchybar --set "docker.child.${PROJECT}.${IDX}" drawing=on
		IDX=$((IDX + 1))
	done
	sketchybar --set "docker.group.${PROJECT}" icon=󰅀
fi

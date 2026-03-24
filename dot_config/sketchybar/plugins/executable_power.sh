#!/bin/bash
source "$CONFIG_DIR/colors.sh"

show_popup() {
	OLD=$(sketchybar --query power | jq -r '.popup.items[]' 2>/dev/null | grep "power\.")
	for item in $OLD; do
		sketchybar --remove "$item" 2>/dev/null
	done

	ITEMS=(
		"power.lock|󰌾|Lock|pmset displaysleepnow"
		"power.sleep|󰤄|Sleep|pmset sleepnow"
		"power.restart|󰜉|Restart|osascript -e 'tell app \"System Events\" to restart'"
		"power.shutdown|⏻|Shut Down|osascript -e 'tell app \"System Events\" to shut down'"
		"power.logout|󰍃|Log Out|osascript -e 'tell app \"System Events\" to log out'"
	)

	for entry in "${ITEMS[@]}"; do
		IFS='|' read -r INAME IICON ILABEL ICMD <<< "$entry"

		if [ "$INAME" = "power.shutdown" ] || [ "$INAME" = "power.logout" ]; then
			ICOLOR=$ACCENT_RED
		else
			ICOLOR=$FG_COLOR
		fi

		sketchybar \
			--add item "$INAME" popup.power \
			--set "$INAME" \
			icon="$IICON" \
			icon.color="$ICOLOR" \
			icon.font="SF Pro:Semibold:17.0" \
			icon.padding_left=10 \
			label="$ILABEL" \
			label.font="SF Pro:Medium:13.0" \
			label.color="$ICOLOR" \
			label.padding_right=10 \
			background.drawing=off \
			click_script="sketchybar --set power popup.drawing=off; $ICMD"
	done
}

case "$SENDER" in
	"mouse.clicked")
		DRAWING=$(sketchybar --query power | jq -r '.popup.drawing')
		if [ "$DRAWING" = "on" ]; then
			sketchybar --set power popup.drawing=off
		else
			show_popup
			sketchybar --set power popup.drawing=on
		fi
		;;
	"mouse.exited.global")
		sketchybar --set power popup.drawing=off
		;;
esac

#!/bin/bash

# Define all the items that can be used in the bar.

calendar() {
	sketchybar \
		--add item calendar "$1" \
		--set calendar \
		update_freq=30 \
		icon=􀧞 \
		script="$PLUGIN_DIR/calendar.sh"
}

volume() {
	sketchybar \
		--add item volume "$1" \
		--subscribe volume volume_change \
		--set volume \
		script="$PLUGIN_DIR/volume.sh"
}

battery() {
	sketchybar \
		--add item battery "$1" \
		--subscribe battery system_woke power_source_change \
		--set battery \
		update_freq=120 \
		script="$PLUGIN_DIR/battery.sh"
}

cpu() {
	sketchybar \
		--add item cpu "$1" \
		--set cpu \
		update_freq=2 \
		icon=􀧓 \
		script="$PLUGIN_DIR/cpu.sh"
}

front_app() {
	sketchybar \
		--add item front_app "$1" \
		--subscribe front_app front_app_switched \
		--set front_app \
		background.color=$ACCENT_COLOR \
		icon.color=$BAR_COLOR \
		icon.font="sketchybar-app-font:Regular:16.0" \
		label.color=$BAR_COLOR \
		script="$PLUGIN_DIR/front_app.sh"
}

spaces() {
	SPACE_SIDS=(1 2 3 4 5 6 7 8 9 10)
	for sid in "${SPACE_SIDS[@]}"; do
		sketchybar --add space space.$sid "$1" \
			--set space.$sid \
			space=$sid \
			icon=$sid \
			label.font="sketchybar-app-font:Regular:16.0" \
			label.padding_right=20 \
			label.y_offset=-1 \
			script="$PLUGIN_DIR/space.sh"
	done

	sketchybar --add item space_separator "$1" \
		--set space_separator \
		icon="􀆊" \
		icon.color=$ACCENT_COLOR \
		icon.padding_left=4 \
		label.drawing=off \
		background.drawing=off \
		script="$PLUGIN_DIR/space_windows.sh" \
		--subscribe space_separator space_windows_change
}

media() {
	sketchybar \
		--add item media "$1" \
		--subscribe media media_change \
		--set media \
		label.color=$ACCENT_COLOR \
		label.max_chars=20 \
		icon.padding_left=0 \
		scroll_texts=on \
		icon=􀑪 \
		icon.color=$ACCENT_COLOR \
		background.drawing=off \
		script="$PLUGIN_DIR/media.sh"
}

wifi() {
	wifi=(
		icon="􀙈 "
		icon.color="$ACCENT_COLOR"
		script="$PLUGIN_DIR/wifi.sh"
	)

	sketchybar \
		--add item wifi "$1" \
		--set wifi "${wifi[@]}" \
		--subscribe wifi wifi_change mouse.clicked
}

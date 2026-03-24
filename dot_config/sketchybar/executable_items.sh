#!/bin/bash

# ── Pill style helper ────────────────────────────────────────
PILL=(
	background.color=$BAR_COLOR
	background.corner_radius=12
	background.height=30
	background.drawing=on
	blur_radius=30
)

spacer() {
	sketchybar \
		--add item spacer.$2 "$1" \
		--set spacer.$2 \
		width=8 \
		background.drawing=off \
		icon.drawing=off \
		label.drawing=off
}

datetime() {
	sketchybar \
		--add item datetime "$1" \
		--subscribe datetime mouse.clicked \
		--set datetime \
		update_freq=10 \
		icon=󰥔 \
		script="$PLUGIN_DIR/datetime.sh" \
		click_script="$PLUGIN_DIR/datetime_click.sh"
}

volume() {
	sketchybar \
		--add item volume "$1" \
		--subscribe volume volume_change mouse.scrolled \
		--set volume \
		script="$PLUGIN_DIR/volume.sh" \
		click_script="$PLUGIN_DIR/volume_click.sh"
}

battery() {
	sketchybar \
		--add item battery "$1" \
		--subscribe battery system_woke power_source_change mouse.clicked mouse.exited.global \
		--set battery \
		update_freq=120 \
		popup.align=right \
		popup.background.color=$ITEM_BG_COLOR \
		popup.background.corner_radius=8 \
		popup.background.border_color=$MUTED_COLOR \
		popup.background.border_width=1 \
		script="$PLUGIN_DIR/battery.sh"

	sketchybar \
		--add item battery.time popup.battery \
		--set battery.time \
		icon=󰁫 \
		icon.color=$FG_DIM \
		label.color=$FG_COLOR \
		label.font="SF Pro:Medium:13.0" \
		background.drawing=off

	sketchybar \
		--add item battery.lowpower popup.battery \
		--set battery.lowpower \
		icon=󱈏 \
		icon.color=$ACCENT_YELLOW \
		label="Low Power Mode" \
		label.color=$FG_COLOR \
		label.font="SF Pro:Medium:13.0" \
		background.drawing=off \
		click_script="$PLUGIN_DIR/battery_toggle_lpm.sh"
}

cpu() {
	sketchybar \
		--add item cpu "$1" \
		--set cpu \
		update_freq=4 \
		icon=󰍛 \
		script="$PLUGIN_DIR/cpu.sh"
}

caffeine() {
	sketchybar \
		--add item caffeine "$1" \
		--subscribe caffeine mouse.clicked \
		--set caffeine \
		update_freq=30 \
		icon=󰒲 \
		label.drawing=off \
		script="$PLUGIN_DIR/caffeine.sh"
}

wifi() {
	sketchybar \
		--add item wifi "$1" \
		--subscribe wifi wifi_change \
		--set wifi \
		icon=󰤨 \
		label.drawing=off \
		script="$PLUGIN_DIR/wifi.sh" \
		click_script="open x-apple.systempreferences:com.apple.wifi-settings-extension"
}

bluetooth() {
	sketchybar \
		--add item bluetooth "$1" \
		--subscribe bluetooth mouse.clicked mouse.exited.global \
		--set bluetooth \
		update_freq=30 \
		icon=󰂯 \
		popup.align=right \
		popup.background.color=$ITEM_BG_COLOR \
		popup.background.corner_radius=8 \
		popup.background.border_color=$MUTED_COLOR \
		popup.background.border_width=1 \
		script="$PLUGIN_DIR/bluetooth.sh"
}

docker() {
	sketchybar \
		--add item docker "$1" \
		--subscribe docker mouse.clicked mouse.exited.global \
		--set docker \
		update_freq=10 \
		icon=󰡨 \
		popup.align=right \
		popup.background.color=$ITEM_BG_COLOR \
		popup.background.corner_radius=8 \
		popup.background.border_color=$MUTED_COLOR \
		popup.background.border_width=1 \
		popup.height=25 \
		script="$PLUGIN_DIR/docker.sh"
}

front_app() {
	sketchybar \
		--add item front_app "$1" \
		--subscribe front_app front_app_switched \
		--set front_app \
		icon.color=$BAR_COLOR \
		label.color=$BAR_COLOR \
		icon.font="sketchybar-app-font:Regular:16.0" \
		script="$PLUGIN_DIR/front_app.sh"
}

spaces() {
	for sid in $(seq 1 5); do
		sketchybar --add space space.$sid "$1" \
			--set space.$sid \
			space=$sid \
			icon=$sid \
			icon.font="SF Pro:Bold:13.0" \
			label.font="sketchybar-app-font:Regular:14.0" \
			label.padding_right=18 \
			label.y_offset=-1 \
			script="$PLUGIN_DIR/space.sh" \
			click_script="yabai -m space --focus $sid"
	done

	# Bracket pill around spaces
	SPACE_ITEMS=$(for sid in $(seq 1 5); do echo -n "space.$sid "; done)
	sketchybar --add bracket spaces_pill $SPACE_ITEMS \
		--set spaces_pill "${PILL[@]}"

	sketchybar --add item space_separator "$1" \
		--set space_separator \
		icon=󰇙 \
		icon.color=$MUTED_COLOR \
		icon.font="SF Pro:Bold:14.0" \
		icon.padding_left=4 \
		label.drawing=off \
		background.drawing=off \
		script="$PLUGIN_DIR/space_windows.sh" \
		--subscribe space_separator space_windows_change
}

media() {
	sketchybar \
		--add item media "$1" \
		--subscribe media media_change mouse.scrolled \
		--set media \
		update_freq=5 \
		label.color=$FG_COLOR \
		label.max_chars=30 \
		scroll_texts=on \
		icon=󰎈 \
		icon.color=$ACCENT_COLOR \
		background.color=$BAR_COLOR \
		background.corner_radius=12 \
		background.height=30 \
		background.drawing=on \
		script="$PLUGIN_DIR/media.sh" \
		click_script="$PLUGIN_DIR/media_click.sh"
}

# ── Pill brackets (called after items are added) ─────────────
apply_pills() {
	sketchybar --add bracket front_app_pill front_app \
		--set front_app_pill "${PILL[@]}" \
		background.color=$ACCENT_COLOR

	sketchybar --add bracket datetime_pill datetime \
		--set datetime_pill "${PILL[@]}"

	sketchybar --add bracket network_pill wifi bluetooth \
		--set network_pill "${PILL[@]}"

	sketchybar --add bracket audio_pill volume \
		--set audio_pill "${PILL[@]}"

	sketchybar --add bracket power_pill battery cpu caffeine \
		--set power_pill "${PILL[@]}"

	sketchybar --add bracket docker_pill docker \
		--set docker_pill "${PILL[@]}"
}

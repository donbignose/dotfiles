#!/bin/bash
source "$CONFIG_DIR/colors.sh"

update() {
	if pgrep -q "Docker Desktop"; then
		CONTAINERS=$(/usr/local/bin/docker info --format '{{.ContainersRunning}}' 2>/dev/null)
		CONTAINERS=${CONTAINERS:-0}

		if [ "$CONTAINERS" -gt 0 ]; then
			LABEL="$CONTAINERS"
			COLOR=$ACCENT_COLOR
		else
			LABEL=""
			COLOR=$FG_DIM
		fi
		sketchybar --set "$NAME" icon="󰡨" icon.color="$COLOR" label="$LABEL" label.drawing=on
	else
		sketchybar --set "$NAME" icon="󰡨" icon.color="$MUTED_COLOR" label.drawing=off
	fi
}

toggle_group() {
	PROJECT="$1"
	# Check if child items are currently visible
	FIRST_CHILD="docker.child.${PROJECT}.0"
	VISIBLE=$(sketchybar --query "$FIRST_CHILD" 2>/dev/null | jq -r '.label.drawing' 2>/dev/null)

	if [ "$VISIBLE" = "on" ]; then
		# Collapse — hide all children
		IDX=0
		while sketchybar --query "docker.child.${PROJECT}.${IDX}" &>/dev/null; do
			sketchybar --set "docker.child.${PROJECT}.${IDX}" drawing=off
			IDX=$((IDX + 1))
		done
		sketchybar --set "docker.group.${PROJECT}" icon=󰅂
	else
		# Expand — show all children
		IDX=0
		while sketchybar --query "docker.child.${PROJECT}.${IDX}" &>/dev/null; do
			sketchybar --set "docker.child.${PROJECT}.${IDX}" drawing=on
			IDX=$((IDX + 1))
		done
		sketchybar --set "docker.group.${PROJECT}" icon=󰅀
	fi
}

show_popup() {
	# Remove old popup items
	OLD=$(sketchybar --query docker | jq -r '.popup.items[]' 2>/dev/null | grep "docker\.")
	for item in $OLD; do
		sketchybar --remove "$item" 2>/dev/null
	done

	# Open Dashboard
	sketchybar \
		--add item docker.dashboard popup.docker \
		--set docker.dashboard \
		icon=󰡨 \
		icon.color=$ACCENT_COLOR \
		icon.font="SF Pro:Semibold:17.0" \
		label="Open Dashboard" \
		label.font="SF Pro:Medium:13.0" \
		label.color=$ACCENT_COLOR \
		background.drawing=off \
		click_script="open -a 'Docker Desktop'; sketchybar --set docker popup.drawing=off"

	sketchybar \
		--add item docker.sep popup.docker \
		--set docker.sep \
		icon.drawing=off \
		label="────────────────" \
		label.font="SF Pro:Medium:8.0" \
		label.color=$MUTED_COLOR \
		label.padding_left=10 \
		label.padding_right=10 \
		background.drawing=off

	# Build groups from container labels
	PROJECTS=$(/usr/local/bin/docker ps --format '{{.Label "com.docker.compose.project"}}' 2>/dev/null | sort -u | grep -v '^$')

	for PNAME in $PROJECTS; do
		SAFE_NAME=$(echo "$PNAME" | tr -c 'a-zA-Z0-9_' '_')
		DISPLAY_NAME="${PNAME:0:28}"
		COUNT=$(/usr/local/bin/docker ps --filter "label=com.docker.compose.project=$PNAME" --format '{{.ID}}' 2>/dev/null | wc -l | tr -d ' ')

		PCOLOR=$ACCENT_GREEN

		# Group header
		sketchybar \
			--add item "docker.group.${SAFE_NAME}" popup.docker \
			--set "docker.group.${SAFE_NAME}" \
			icon=󰅂 \
			icon.color="$PCOLOR" \
			icon.font="SF Pro:Semibold:14.0" \
			icon.padding_left=10 \
			label="$DISPLAY_NAME ($COUNT)" \
			label.font="SF Pro:Semibold:12.0" \
			label.color="$ACCENT_COLOR" \
			label.padding_right=10 \
			background.drawing=off \
			click_script="$CONFIG_DIR/plugins/docker_toggle.sh $SAFE_NAME"

		# Child containers (hidden by default)
		CHILD_IDX=0
		while IFS='|' read -r CNAME CSTATUS; do
			[ -z "$CNAME" ] && continue

			SHORT_NAME=$(echo "$CNAME" | sed "s/^${PNAME}[-_]//;s/[-_][0-9]*$//")
			SHORT_NAME="${SHORT_NAME:0:25}"

			if echo "$CSTATUS" | grep -q "healthy"; then
				CICON="󰗠"
				CCOLOR=$ACCENT_GREEN
			elif echo "$CSTATUS" | grep -q "Up"; then
				CICON="󰐌"
				CCOLOR=$ACCENT_YELLOW
			else
				CICON="󰜺"
				CCOLOR=$MUTED_COLOR
			fi

			sketchybar \
				--add item "docker.child.${SAFE_NAME}.${CHILD_IDX}" popup.docker \
				--set "docker.child.${SAFE_NAME}.${CHILD_IDX}" \
				icon="$CICON" \
				icon.color="$CCOLOR" \
				icon.font="SF Pro:Medium:12.0" \
				icon.padding_left=28 \
				label="$SHORT_NAME" \
				label.font="SF Pro:Medium:11.0" \
				label.color="$MUTED_COLOR" \
				label.padding_right=10 \
				background.drawing=off \
				drawing=off

			CHILD_IDX=$((CHILD_IDX + 1))
		done < <(/usr/local/bin/docker ps --filter "label=com.docker.compose.project=$PNAME" --format '{{.Names}}|{{.Status}}' 2>/dev/null)
	done

	# Standalone containers (no compose label)
	while IFS='|' read -r CNAME CSTATUS; do
		[ -z "$CNAME" ] && continue
		DISPLAY_NAME="${CNAME:0:28}"

		if echo "$CSTATUS" | grep -q "healthy\|Up"; then
			CICON="󰗠"
			CCOLOR=$ACCENT_GREEN
		else
			CICON="󰐌"
			CCOLOR=$ACCENT_YELLOW
		fi

		sketchybar \
			--add item "docker.standalone.${CNAME}" popup.docker \
			--set "docker.standalone.${CNAME}" \
			icon="$CICON" \
			icon.color="$CCOLOR" \
			icon.font="SF Pro:Semibold:14.0" \
			icon.padding_left=10 \
			label="$DISPLAY_NAME" \
			label.font="SF Pro:Medium:12.0" \
			label.color="$ACCENT_COLOR" \
			label.padding_right=10 \
			background.drawing=off
	done < <(/usr/local/bin/docker ps --filter "label!=com.docker.compose.project" --format '{{.Names}}|{{.Status}}' 2>/dev/null)

	# Quit
	sketchybar \
		--add item docker.sep2 popup.docker \
		--set docker.sep2 \
		icon.drawing=off \
		label="────────────────" \
		label.font="SF Pro:Medium:8.0" \
		label.color=$MUTED_COLOR \
		label.padding_left=10 \
		label.padding_right=10 \
		background.drawing=off

	sketchybar \
		--add item docker.quit popup.docker \
		--set docker.quit \
		icon=󰅙 \
		icon.color=$ACCENT_RED \
		icon.font="SF Pro:Semibold:17.0" \
		label="Quit Docker Desktop" \
		label.font="SF Pro:Medium:13.0" \
		label.color=$ACCENT_RED \
		background.drawing=off \
		click_script="osascript -e 'quit app \"Docker Desktop\"'; sketchybar --set docker popup.drawing=off"
}

case "$SENDER" in
	"mouse.clicked")
		if ! pgrep -q "Docker Desktop"; then
			open -a "Docker Desktop"
		else
			DRAWING=$(sketchybar --query "$NAME" | jq -r '.popup.drawing')
			if [ "$DRAWING" = "on" ]; then
				sketchybar --set "$NAME" popup.drawing=off
			else
				show_popup
				sketchybar --set "$NAME" popup.drawing=on
			fi
		fi
		;;
	"mouse.exited.global")
		sketchybar --set "$NAME" popup.drawing=off
		;;
	*)
		update
		;;
esac

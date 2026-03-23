#!/bin/bash
CPU_PERCENT=$(top -l 1 -n 0 | awk '/CPU usage/ {printf "%.0f", $3 + $5}')
sketchybar --set "$NAME" label="${CPU_PERCENT}%"

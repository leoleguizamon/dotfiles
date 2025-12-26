#!/usr/bin/env bash

PID=$(pgrep -x wf-recorder)

if [ -n "$PID" ];then
	# Detener grabación
	killall wf-recorder
	notify-send -u low "Recording stopped" "$(basename "$FILE")"
fi

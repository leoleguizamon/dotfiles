#!/bin/bash

# Encuentra el PID de waybar
WAYBAR_PID=$(pidof waybar)

# Envía la señal SIGUSR1
kill -SIGUSR1 $WAYBAR_PID

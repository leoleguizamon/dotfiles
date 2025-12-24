#!/bin/bash

APP="$1"

if [ -z "$APP" ]; then
    echo "Uso: $0 <programa>"
    exit 1
fi

if pgrep -f "^$APP\$" > /dev/null; then
    pkill -f "^$APP\$"
else
    "$APP" &
fi


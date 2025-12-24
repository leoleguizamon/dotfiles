#!/bin/bash

LOCKFILE="/tmp/ddcutil.lock"
STATEFILE="/tmp/waybar-ddc-mode"
STEP=20

# Valores VCP
BRIGHTNESS_VCP=10
CONTRAST_VCP=12


# Estado por defecto
[ ! -f "$STATEFILE" ] && echo "brightness" > "$STATEFILE"
MODE=$(cat "$STATEFILE")

# Selección de modo
if [ "$MODE" = "brightness" ]; then
    VCP=$BRIGHTNESS_VCP
    ICON="󰃠"
    LABEL="Brightness"
else
    VCP=$CONTRAST_VCP
    ICON="󰆗"
    LABEL="Contrast"
fi

# Acciones
case "$1" in
    up)
        timeout 1.5s ddcutil --noverify --sleep-multiplier=0.1 setvcp "$VCP" + "$STEP"
        ;;
    down)
        timeout 1.5s ddcutil --noverify --sleep-multiplier=0.1 setvcp "$VCP" - "$STEP"
        ;;
    toggle)
        if [ "$MODE" = "brightness" ]; then
            echo "contrast" > "$STATEFILE"
        else
            echo "brightness" > "$STATEFILE"
        fi
        ;;
    get)
        # Obtener valor actual
        VALUE=$(ddcutil getvcp "$VCP" 2>/dev/null | \
            awk -F'current value =|,' '{gsub(/ /,"",$2); print $2}')
        # Salida JSON para Waybar
        echo "{\"text\": \"${VALUE}% $ICON\", \"tooltip\": \"$LABEL: ${VALUE}%\"}"
        ;;
esac


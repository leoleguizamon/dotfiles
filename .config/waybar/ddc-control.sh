#!/bin/bash

RECEIVE_PIPE="/tmp/waybar-ddc-module-rx"
STEP=10

# Valores VCP
BRIGHTNESS_VCP=10
CONTRAST_VCP=12

# Estado inicial
MODE="brightness"
VCP=$BRIGHTNESS_VCP
ICON="󰃠"
LABEL="Brightness"

ddcutil_fast() {
    ddcutil --noverify --sleep-multiplier .01 "$@" 2>/dev/null
}

ddcutil_slow() {
    ddcutil --maxtries 15,15,15 "$@" 2>/dev/null
}

print_value() {
    # Obtener valor actual con la función pasada como argumento
    if VALUE=$("$@" -t getvcp "$VCP"); then
        # Extraer solo el valor numérico (campo 4)
        VALUE=$(echo "$VALUE" | cut -d ' ' -f 4)
    else
        VALUE=-1
    fi
    
    # Salida JSON para Waybar
    echo "{\"text\": \"${VALUE}% $ICON\", \"tooltip\": \"$LABEL: ${VALUE}%\"}"
}

# Verificar si hay monitores DDC disponibles
if ! command -v ddcutil &> /dev/null; then
    exit 0
fi

if ! ddcutil detect --brief &> /dev/null; then
    exit 0
fi

# Limpiar y crear pipe
rm -rf "$RECEIVE_PIPE"
mkfifo "$RECEIVE_PIPE"

# Primera lectura
print_value ddcutil_slow

# Bucle principal
while true; do
    read -r command < "$RECEIVE_PIPE"
    
    case "$command" in
        up)
            ddcutil_fast setvcp "$VCP" + "$STEP"
            print_value ddcutil_fast
            ;;
        down)
            ddcutil_fast setvcp "$VCP" - "$STEP"
            print_value ddcutil_fast
            ;;
        max)
            ddcutil_fast setvcp "$VCP" 100
            print_value ddcutil_fast
            ;;
        min)
            ddcutil_fast setvcp "$VCP" 0
            print_value ddcutil_fast
            ;;
        toggle)
            # Cambiar entre brillo y contraste
            if [ "$MODE" = "brightness" ]; then
                VCP=$CONTRAST_VCP
                ICON="󰆗"
                LABEL="Contrast"
                MODE="contrast"
            else
                VCP=$BRIGHTNESS_VCP
                ICON="󰃠"
                LABEL="Brightness"
                MODE="brightness"
            fi
            print_value ddcutil_fast
            ;;
        *)
            ;;
    esac
done
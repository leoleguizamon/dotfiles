#!/usr/bin/env bash

# Ruta y nombre de archivo
DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"
FILENAME="$DIR/rec$(date +'%d%m%y-%H%M%S').mkv"
WAYBAR_SIGNAL="SIGUSR1"

case $1 in
    0)
        # Grabar con sonido
        AREA=$(slurp -b "1b032977" -c "39ff14" -w 1)
        if [ -z "$AREA" ]; then
            notify-send -u normal "Recording cancelled" "No valid area selected"
            exit 1
        fi

        notify-send -u low "Recording with sound started" "$(basename "$FILENAME")"
        wf-recorder --audio --cursor -g "$AREA" -f "$FILENAME" & 
        disown
        
        # Enviar señal a Waybar para mostrar módulo
        pkill -RTMIN+8 waybar
        ;;
    1)
        # Grabar sin sonido
        AREA=$(slurp -b "1b032977" -c "39ff14" -w 1)
        if [ -z "$AREA" ]; then
            notify-send -u normal "Recording cancelled" "No valid area selected"
            exit 1
        fi

        notify-send -u low "Recording without sound started" "Selected area"
        wf-recorder --cursor -g "$AREA" -f "$FILENAME" & 
        disown

        # Enviar señal a Waybar para mostrar módulo
        pkill -RTMIN+8 waybar
        ;;
    2)
        #Detener grabaciones
        PID=$(pgrep -x wf-recorder)

        if [ -n "$PID" ];then
            # Detener grabación
            killall wf-recorder
            notify-send -u low "Recording stopped"
        fi
        ;;
    *)
        notify-send -u critical "Invalid option"
        ;;
esac

#!/bin/bash

# Power menu script with confirmation using zenity
# Usage: ./power-menu.sh [shutdown|reboot|suspend|logout]

ACTION="$1"

case "$ACTION" in
    shutdown)
        zenity --question \
            --title="Shutdown System" \
            --text="Are you sure you want to shutdown the system?" \
            --icon="system-shutdown" \
            --width=300 \
            --ok-label="Shutdown" \
            --cancel-label="Cancel"
        
        if [ $? -eq 0 ]; then
            systemctl poweroff
        fi
        ;;
    
    reboot)
        zenity --question \
            --title="Reboot System" \
            --text="Are you sure you want to reboot the system?" \
            --icon="system-reboot" \
            --width=300 \
            --ok-label="Reboot" \
            --cancel-label="Cancel"
        
        if [ $? -eq 0 ]; then
            systemctl reboot
        fi
        ;;
    
    suspend)
        zenity --question \
            --title="Suspend System" \
            --text="Are you sure you want to suspend the system?" \
            --icon="system-suspend" \
            --width=300 \
            --ok-label="Suspend" \
            --cancel-label="Cancel"
        
        if [ $? -eq 0 ]; then
            swaylock && systemctl suspend
        fi
        ;;
    
    logout)
        zenity --question \
            --title="Log Out" \
            --text="Are you sure you want to log out?" \
            --icon="system-log-out" \
            --width=300 \
            --ok-label="Log Out" \
            --cancel-label="Cancel"
        
        if [ $? -eq 0 ]; then
            swaymsg exit
        fi
        ;;
    
    *)
        echo "Usage: $0 {shutdown|reboot|suspend|logout}"
        exit 1
        ;;
esac
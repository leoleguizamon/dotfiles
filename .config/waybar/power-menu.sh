#!/bin/bash

# Power menu script with confirmation using yad
# Usage: ./power-menu.sh [shutdown|reboot|suspend|logout]

ACTION="$1"

case "$ACTION" in
    shutdown)
        yad --question \
            --title="Shutdown System" \
            --text="Are you sure you want to shutdown the system?" \
            --image="system-shutdown" \
            --width=300 \
            --button="Cancel:1" \
            --button="Shutdown:0"
        
        if [ $? -eq 0 ]; then
            systemctl poweroff
        fi
        ;;
    
    reboot)
        yad --question \
            --title="Reboot System" \
            --text="Are you sure you want to reboot the system?" \
            --image="system-reboot" \
            --width=300 \
            --button="Cancel:1" \
            --button="Reboot:0"
        
        if [ $? -eq 0 ]; then
            systemctl reboot
        fi
        ;;
    
    suspend)
        yad --question \
            --title="Suspend System" \
            --text="Are you sure you want to suspend the system?" \
            --image="system-suspend" \
            --width=300 \
            --button="Cancel:1" \
            --button="Suspend:0"
        
        if [ $? -eq 0 ]; then
            swaylock && systemctl suspend
        fi
        ;;
    
    logout)
        yad --question \
            --title="Log Out" \
            --text="Are you sure you want to log out?" \
            --image="system-log-out" \
            --width=300 \
            --button="Cancel:1" \
            --button="Log Out:0"
        
        if [ $? -eq 0 ]; then
            swaymsg exit
        fi
        ;;
    
    *)
        echo "Usage: $0 {shutdown|reboot|suspend|logout}"
        exit 1
        ;;
esac
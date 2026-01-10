CHASSIS=$(hostnamectl chassis)

while true; do

#### Estado de la red ####
	
	# Obtener la conexión activa
	ACTIVE_CONNECTION=$(nmcli -t device | grep ':connected' | head -n1)

	DEVICE=$(echo "$ACTIVE_CONNECTION" | cut -d: -f1)
	TYPE=$(echo "$ACTIVE_CONNECTION" | cut -d: -f2)

	if [ "$TYPE" = "wifi" ]; then
		SSID=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
		SSID="$SSID 󰤨"
	elif [ "$TYPE" = "ethernet" ]; then
		if [[ "$DEVICE" == enx* ]] || [[ "$DEVICE" == usb* ]]; then
			SSID="Bridged 󰌘"
		else
			SSID="$DEVICE 󰈀"
		fi
	elif [ "$TYPE" = "loopback" ]; then
		SSID="Offline 󰌙"
	else
		SSID="Unknown "
	fi

	# Obtener IP de conexión activa
	IP=$(nmcli -t -f IP4.ADDRESS device show "$DEVICE" | cut -d: -f2)

	if [ "$TYPE" = "loopback" ]; then
		IP="$IP 󱦂"
	else
		IP="$IP 󰩟"
	fi

#### Estado de la batería ####

	# Obtener fuente de energía
	AC=$(cat /sys/class/power_supply/AC0/online)
	
	# Obtener nivel de batería
	BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)
	# Cambiar icono dependiendo del nivel de batería
	if [ "$BATTERY" -gt "90" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰂅' || echo '󰁹' )"
	elif [ "$BATTERY" -gt "80" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰂊' || echo '󰂁' )"
	elif [ "$BATTERY" -gt "70" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰢞' || echo '󰂀' )"
	elif [ "$BATTERY" -gt "60" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰂉' || echo '󰁿' )"
	elif [ "$BATTERY" -gt "50" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰢝' || echo '󰁾' )"
	elif [ "$BATTERY" -gt "40" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰂈' || echo '󰁽' )"
	elif [ "$BATTERY" -gt "30" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰂇' || echo '󰁼' )"
	elif [ "$BATTERY" -gt "20" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰂆' || echo '󰁻' )"
	elif [ "$BATTERY" -gt "10" ]; then
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰢜' || echo '󰁺' )"
	else
		BATTERY="$BATTERY $( [ "$AC" -eq 1 ] && echo '󰢟' || echo '󰂃' )"
	fi


### Obtener brillo ####
	SCREEN=false
	if [ "$CHASSIS" = "laptop" ] || [ "$CHASSIS" = "convertible" ] || [ "$CHASSIS" = "tablet" ] || [ "$CHASSIS" = "handset" ]; then
		SCREEN=true
	fi
	if [ "$SCREEN" = true ]; then
		# Obtener brillo
		BRIGHTNESS=$(brightnessctl get)
		MAX_BRIGHTNESS=$(brightnessctl max)

		# Normalizar brillo
		BRIGHTNESS=$(( $BRIGHTNESS * 100 / $MAX_BRIGHTNESS ))

		# Cambiar icono dependiendo del brillo
		if [ "$BRIGHTNESS" -gt "60" ]; then
			BRIGHTNESS="$BRIGHTNESS 󰃠"
		elif [ "$BRIGHTNESS" -gt "30" ]; then
			BRIGHTNESS="$BRIGHTNESS 󰃟"
		else
			BRIGHTNESS="$BRIGHTNESS 󰃞"
		fi
	fi
	# Obtener temperatura
	TEMP=100
	TEMP=""
	for zone in /sys/class/thermal/thermal_zone*; do
		type=$(<"$zone/type")
		if [[ "$type" == "x86_pkg_temp" ]]; then
			raw_temp=$(<"$zone/temp")
			TEMP=$(awk "BEGIN { printf \"%.1f\", $raw_temp / 1000 }")
			break
		fi
	done
	
	TEMP=$(sensors | awk '/Core 0:/ { print $3; exit }' | tr -d '+°C')
	
	if [ "$TEMP" -ge 65 ]; then
		TEMP="$TEMP󰔄 "
	elif [ "$TEMP" -ge 50 ]; then
		TEMP="$TEMP󰔄 "
	elif [ "$TEMP" -ge 40 ]; then
		TEMP="$TEMP󰔄 "
	else
		TEMP="$TEMP󰔄 "
	fi
	

#### Datos basicos ####

	# Obtener título de la ventana activa
	WINDOW=$(swaymsg -t get_tree | awk '/"focused"[[:space:]]*:[[:space:]]*true/ {
		while (getline) {
			if (/"name"[[:space:]]*:[[:space:]]*"/) {
				match($0, /"name"[[:space:]]*:[[:space:]]*"([^"]*)"/, arr)
				split(arr[1], parts, " - ")
				print parts[length(parts)]
				exit
			}
		}
	}')

	# Fecha
	DATE=$(date +"%d / %m / %y ")󰃭

	# Hora
	TIME=$(date +"%H:%M ")󱑅

	VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
	MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED")

	# Cambiar icono dependiendo del nivel de volumen o si está muteado
	if [ -n "$MUTED" ]; then
		VOLUME="$VOLUME 󰝟"
	elif [ "$VOLUME" -eq "0" ]; then
		VOLUME="$VOLUME 󰸈"
	elif [ "$VOLUME" -lt "10" ]; then
		VOLUME="$VOLUME 󰕿"
	elif [ "$VOLUME" -lt "30" ]; then
		VOLUME="$VOLUME 󰖀"
	elif [ "$VOLUME" -lt "70" ]; then
		VOLUME="$VOLUME 󰕾"
	else
		VOLUME="$VOLUME 󰕾"
	fi

#### Imprimir barra ####

	# Tipo de barra segun segun chasis
	if [ "$CHASSIS" = "desktop" ]; then
		echo -n " $WINDOW  $SSID  $IP  $VOLUME  $TEMP  $DATE   $TIME   "
	elif [ "$SCREEN" = true ]; then
		echo -n " $WINDOW  $SSID  $IP  $VOLUME  $BRIGHTNESS  $BATTERY  $TEMP  $DATE   $TIME   "
	else
		echo -n " $WINDOW  $SSID  $IP  $VOLUME  $DATE   $TIME   "
	fi
	sleep 1

done


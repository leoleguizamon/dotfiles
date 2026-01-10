# Ruta y nombre de archivo
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILENAME="$DIR/ss$(date +'%d%m%y-%H%M%S').png"

case $1 in
	0)
		# Capturar área seleccionada
		AREA=$(slurp -b "1b032977" -c "39ff14")
		if [ -z "$AREA" ]; then
			notify-send -u normal "Screenshot cancelled" "No valid area selected"
			exit 1
		fi

		grim -g "$AREA" "$FILENAME"

		# Copiar al portapapeles
		wl-copy < "$FILENAME"
		notify-send -u low "Screenshot - Selected area" "$FILENAME"

		;;	
	1)	
		# Capturar pantalla completa
		grim "$FILENAME"

		# Copiar al portapapeles
		wl-copy < "$FILENAME"
		notify-send -u low "Screenshot - Full screen" "$FILENAME"
		;;
	*)
		notify-send -u critical "Invalid option"
		;;
esac

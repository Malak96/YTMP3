#!/bin/bash
clear
echo "YTMP3 - Buscando actualización"

# Actualizar el repositorio
git pull > temp.txt

# Verificar si hubo cambios
if grep -q "Updating" temp.txt; then
    echo "Se detectaron cambios en el repositorio. Reiniciando..."
    sleep 3
    exec "$0"
    exit
fi

# Eliminar el archivo temporal
rm temp.txt
echo "YTMP3 Downloader"

# Configuraciones
YT_DLP="yt-dlp"
DPATH="descargas"
KBPS=0
MSG_COMPLETE="Se completó la descarga, pulsa una tecla para continuar."
MSG_ERROR="Ocurrió un error:"

# Verificar dependencias
# Verificar si yt-dlp está disponible
if ! command -v "$YT_DLP" &> /dev/null; then
    echo "El archivo yt-dlp no se encuentra en el sistema. Intentando descargarlo..."
    curl -L -o yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    chmod +x yt-dlp
    echo "Reiniciando..."
    sleep 3
    exec "$0"
    exit
fi

# Verificar si ffmpeg está instalado
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg no está instalado. Intentando instalarlo..."
    sudo apt update && sudo apt install -y ffmpeg
    echo "Cerrando. Si las dependencias se instalaron correctamente, vuelve a ejecutar el programa."
    sleep 3
    exit
fi

echo "Todas las dependencias están instaladas correctamente."

# Actualizar yt-dlp a la última versión
echo "Buscando actualizaciones para yt-dlp..."
./"$YT_DLP" -U
sleep 3

# Mostrar banner
while true; do
    clear
    echo
    cat banner.txt
    echo
    echo "Ingresa una URL o presiona Enter para ver las descargas:"
    echo
    read -p "::: " URL
    clear
    echo
    cat banner.txt
    echo
    echo

    # Salir si el usuario ingresa "x"
    if [[ "$URL" == "x" ]]; then
        exit
    fi

    # Abrir carpeta de descargas si el usuario deja el campo vacío
    if [[ -z "$URL" ]]; then
        mkdir -p "$DPATH"
        xdg-open "$DPATH" || echo "Abre manualmente la carpeta $DPATH"
        continue
    fi

    # Descargar el video/audio
    echo "Descargando el archivo..."
    echo
    "./$YT_DLP" \
        --format bestaudio/best \
        --output "$DPATH/%(title)s.%(ext)s" \
        --embed-thumbnail \
        --add-metadata \
        --ppa "ffmpeg:-id3v2_version 3" \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality "$KBPS" \
        --no-playlist \
        "$URL"
    URL=""

    # Confirmar descarga completada
    if [ $? -ne 0 ]; then
        echo "$MSG_ERROR"
    else
        echo "$MSG_COMPLETE"
    fi
done

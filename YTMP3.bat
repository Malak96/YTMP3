@echo off
title YTMP3 - Buscando actualizacion

:: Actualizar el repositorio
git pull > temp.txt

:: Verificar si hubo cambios
find "Updating" temp.txt > nul
if %errorlevel% equ 0 (
    echo Se detectaron cambios en el repositorio. Reiniciando...
    timeout /t 3 /nobreak > nul
    start "" "%~f0"
    exit
)

:: Eliminar el archivo temporal
del temp.txt
pause
:: Actualizar yt_dlp
python -m pip install -U yt-dlp

:: Ejecutar el script
python YTMP3_v2.py


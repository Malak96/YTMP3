@echo off
title YTMP3 - Actualización Automática

:: Actualizar el repositorio
git pull

:: Actualizar yt_dlp a la última versión
python -m pip install -U yt-dlp

:: Ejecutar el script
python YTMP3_v2.py

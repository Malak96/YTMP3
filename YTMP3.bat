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
title YTMP3 Downloader
:: Configuraciones
set "YT_DLP=yt-dlp.exe"
set "dpath=descargas"
set "kbps=0"
set "msg_complete=Se completo la descarga, pulsa una tecla para continuar."
set "msg_error=Ocurrio un error:"

:: Verificar si el ejecutable yt-dlp existe
if not exist "%YT_DLP%" (
    echo El archivo yt-dlp.exe no se encuentra en el directorio. Descargando...
    curl -L -o yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
)

:: Actualizar yt-dlp a la última versión
echo Buscando actualizaciones para yt-dlp...
"%YT_DLP%" -U

:banner
cls 
echo.
type banner.txt
echo.
:inicio
echo.
echo Ingresa una URL o pesiona Enter para ver las descargas:
echo.
set /p "URL=::: "
cls 
echo.
type banner.txt
echo.
echo.
:: Salir si el usuario ingresa "x"
if /i "%URL%"=="x" exit /b

:: Abrir carpeta de descargas si el usuario deja el campo vacío
if "%URL%"=="" (
    if not exist "%dpath%" mkdir "%dpath%"
    start "" "%dpath%"
    goto :banner
)

:: Descargar el video/audio
echo Descargando el archivo...
echo.
"%YT_DLP%" ^
    --format bestaudio/best ^
    --output "%dpath%\%%(title)s.%%(ext)s" ^
    --embed-thumbnail ^
    --add-metadata ^
    --postprocessor-args "-id3v2_version 3" ^
    --extract-audio ^
    --audio-format mp3 ^
    --audio-quality %kbps% ^
    --no-playlist ^
    "%URL%"
set URL=
:: Confirmar descarga completada
if errorlevel 1 (
    echo %msg_error%
) else (
    echo %msg_complete%
)

goto inicio


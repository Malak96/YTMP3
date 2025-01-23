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
set "msg_complete=Se completo la tarea."
set "msg_error=Ocurrio un error:"
set SHORTCUT_PATH=%~dp0YTMP3.lnk
set VBS_SCRIPT=%~dp0vs_lnk.vbs
:: Verificar dependencias
:: Verificar si yt-dlp está disponible
set YT_DLP=yt-dlp.exe
if not exist "%YT_DLP%" (
    echo El archivo yt-dlp.exe no se encuentra en el directorio. Intentando descargarlo...
    curl -L -o yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
    echo Reiniciando...
    timeout /t 3 /nobreak > nul
    start "" "%~f0"
    exit
)

:: Verificar si ffmpeg está instalado
ffmpeg -version >nul 2>nul
if %errorlevel% neq 0 (
    echo ffmpeg no esta instalado. Intentando instalarlo...
    winget install ffmpeg
    echo Cerrando si las dependecias se instalaron correctamente vuelve a ejecutar el programa.
    timeout /t 3 /nobreak > nul
    exit
)

echo Todas las dependencias estan instaladas correctamente.


:: Verificar si el acceso directo ya existe en la carpeta raíz
if exist "%SHORTCUT_PATH%" (
    echo Acceso directo OK.
) else (
    :: Si el acceso directo no existe, ejecutar el script VBScript
    echo Creando acceso directo...
    :: Verificar si el script VBScript existe
    if exist "%VBS_SCRIPT%" (
        echo Ejecutando script VBScript para crear accesos directos...
        cscript //nologo "%VBS_SCRIPT%" "%~dp0%~nx0"
    ) else (
        echo No se encontró el archivo VBScript.
    )
)


:: Actualizar yt-dlp a la última versión
echo Buscando actualizaciones para yt-dlp...
"%YT_DLP%" -U
timeout /t 3 /nobreak > nul

:banner
cls 
echo.
type banner.txt
echo.
:inicio
echo.
echo Ingresa una URL o pesiona Enter para ver las descargas:
echo.
set /p "URL=:::"
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
:: --postprocessor-args "-id3v2_version 3"
echo Descargando el archivo...
echo.
"%YT_DLP%" ^
    --format "bestaudio[ext=m4a]/bestaudio[ext=opus]/bestaudio" ^
    --output "%dpath%\%%(title)s.%%(ext)s" ^
    --embed-thumbnail ^
    --add-metadata ^
    --ppa "ffmpeg:-id3v2_version 3" ^
    --extract-audio ^
    --audio-format mp3 ^
    --audio-quality %kbps% ^
    --no-overwrites ^
    --progress-template "download:%(info.title)s [%(progress.downloaded_bytes|.1f~MiB)s/%(progress.total_bytes|.1f~MiB)s] %(progress.percent|.1f)%%" ^
    --progress-template "postprocess:Processing %(info.title)s: %(progress.percent|.1f)%% done" ^
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


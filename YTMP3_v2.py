import os
import configparser
#from moviepy.audio.io.AudioFileClip import AudioFileClip
import yt_dlp

config = configparser.ConfigParser()

os.system("title YTMP3")
os.system("@echo off")

while True:
    try:
        # Carga la configuración
        config.read('config.ini')
        dpath = config.get('config', 'dpath')
        color = config.get('config', 'color')
        lang = config.get('lang', 'default')
        msg_inf = config.get(lang, 'msg_inf')
        msg_def = config.get(lang, 'msg_def')
        msg_select = config.get(lang, 'msg_select')
        msg_complete = config.get(lang, 'msg_complete')
        msg_error = config.get(lang, 'msg_error')
        msg_push = config.get(lang, 'msg_push')
        os.system(f'color {color}')

        # Limpiar consola
        def clear():
            if os.name == "nt":
                os.system("cls")
            else:
                os.system("clear")
            print("\n██    ██ ████████ ███    ███ ██████  ██████  \n ██  ██     ██    ████  ████ ██   ██      ██ \n  ████      ██    ██ ████ ██ ██████   █████  \n   ██       ██    ██  ██  ██ ██           ██ \n   ██       ██    ██      ██ ██      ██████  \n                                             \n                                             ")
        clear()

        # Solicitar URL del video
        url = str(input(f'{msg_inf}\n:::'))
        if url == 'x':
            break
        if url == '':
            if not os.path.exists(f'{dpath}'):
                os.makedirs(f'{dpath}')
            os.startfile(f'{dpath}')
            continue
        clear()

        # Configurar opciones para yt_dlp
        ydl_opts = {
            'format': 'bestaudio/best',
            'outtmpl': os.path.join(dpath, '%(title)s.%(ext)s'),
            'noplaylist': True,
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': config.get('configmp3', 'kbps') if config.get('configmp3', 'kbps') != 'def' else '0',
            }]
        }

        # Descargar el video/audio
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=True)
            filename = ydl.prepare_filename(info)
            filename_mp3 = filename.replace(info['ext'], 'mp3')
            print("")
            print("")
            print(f'{msg_complete} {filename_mp3}')

        os.system("pause > nul")

    except Exception as e:
        print(f"{msg_error} {e} \n{msg_push}")
        os.system("pause > nul")

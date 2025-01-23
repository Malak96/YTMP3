Dim WshShell, Shortcut, BatPath, IconPath, StartInPath

' Crear objeto Shell
Set WshShell = WScript.CreateObject("WScript.Shell")

' Obtener la ruta del .bat (primer argumento pasado al script VBScript)
BatPath = WScript.Arguments(0)

' Obtener la carpeta donde está el archivo .bat
StartInPath = Left(BatPath, InStrRev(BatPath, "\"))

' Ruta del ícono (ubicado en la misma carpeta que el archivo .bat)
IconPath = StartInPath & "YTMP3.ico"

' Crear acceso directo en la carpeta raíz
Set Shortcut = WshShell.CreateShortcut(StartInPath & "YTMP3.lnk")
Shortcut.TargetPath = BatPath
Shortcut.WorkingDirectory = StartInPath
Shortcut.IconLocation = IconPath
Shortcut.Save

' Crear acceso directo en el Escritorio
Set Shortcut = WshShell.CreateShortcut(WshShell.SpecialFolders("Desktop") & "\YTMP3.lnk")
Shortcut.TargetPath = BatPath
Shortcut.WorkingDirectory = StartInPath
Shortcut.IconLocation = IconPath
Shortcut.Save

' Crear acceso directo en el Menú Inicio
Set Shortcut = WshShell.CreateShortcut(WshShell.SpecialFolders("StartMenu") & "\Programs\YTMP3.lnk")
Shortcut.TargetPath = BatPath
Shortcut.WorkingDirectory = StartInPath
Shortcut.IconLocation = IconPath
Shortcut.Save

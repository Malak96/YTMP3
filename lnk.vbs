Set WshShell = WScript.CreateObject("WScript.Shell")

' Definir el nombre y la ubicación del acceso directo
shortcutName = "YTMP3"
iconName = "YTMP3.ico"
batFilePath = WScript.Arguments(0) ' Recibir la ruta del archivo .bat como argumento

' Carpeta raíz (en la misma carpeta que el script)
shortcutPath = WScript.CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\" & shortcutName & ".lnk"
desktopShortcut = WScript.CreateObject("WScript.Shell").SpecialFolders("Desktop") & "\" & shortcutName & ".lnk"
startMenuShortcut = WScript.CreateObject("WScript.Shell").SpecialFolders("Programs") & "\" & shortcutName & ".lnk"

' Crear el acceso directo en la carpeta raíz
If Not CreateShortcut(shortcutPath, batFilePath, iconName) Then
    WScript.Echo "No se pudo crear el acceso directo en la carpeta raíz."
End If

' Crear el acceso directo en el escritorio
If Not CreateShortcut(desktopShortcut, batFilePath, iconName) Then
    WScript.Echo "No se pudo crear el acceso directo en el escritorio."
End If

' Crear el acceso directo en el menú de inicio
If Not CreateShortcut(startMenuShortcut, batFilePath, iconName) Then
    WScript.Echo "No se pudo crear el acceso directo en el menú de inicio."
End If

' Función para crear un acceso directo
Function CreateShortcut(linkPath, target, icon)
    On Error Resume Next
    Set shortcut = WshShell.CreateShortcut(linkPath)
    shortcut.TargetPath = target
    shortcut.IconLocation = WScript.CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & "\" & icon
    shortcut.Save
    If Err.Number <> 0 Then
        CreateShortcut = False
    Else
        CreateShortcut = True
    End If
    On Error GoTo 0
End Function

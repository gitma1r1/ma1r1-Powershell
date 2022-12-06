# Windows PowerShell-Cheatsheet
##### Öffentliche IP anzeigen

    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    
##### PowerShell 2 auf PowerShell 3.0 aktualisieren (Windows 7)

    // In der cmd-Eingabeaufforderung:
    @powershell -NoProfile -ExecutionPolicy uneingeschränkt -Befehl "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive% \chocolatey\bin cinst Powershell

##### Inhalt einer Datei löschen

    Löschen Sie den Inhalt C:\Dateiname-hier

##### Entspricht dem Linux-Befehl "tail".
   
    // Beendet die letzten 3 Zeilen der angegebenen Datei:
    Get-Content file-name-here -Tail 3
    
##### Äquivalent zu chmod 777 -R

    // Das '/t' steht für rekursiv
    cacls some_folder_here /t /e /g jeder:f
    
    // Neuer Weg
    // Das ':r' soll vorherige Berechtigungen entfernen
    icacls some_folder_here /grant:r Jeder:F /t

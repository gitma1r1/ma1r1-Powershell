# Windows PowerShell-Cheatsheet

##### Get-Command & Get-Member

    Get-Command                                 #so wie help in der cmd 
    Get-Command | Sort-Object comand-type       #sorted output
    Get-Command -Module hyper-v | Out-GridView  #show all hyper-v cmdlets

    Get-ChildItem | Get-Member                      #Eigenschaften this gets you everything
    Get-ChildItem | Get-Member -MemberType Property #Eigenschaften

##### get-help

    get-help Get-Process -Examples #hilfe von einem Befehl
    get-help Get-Process -Online   #help online
    get-help *-item                #Hilfe über alle Befehle mit *-item
    update-help                    #Hilfe aktuallisieren

##### get-alias

    get-alias –Definition Get-ChildItem   #definition parameter to get all aliases for a cmdlet
    get-alias -name ls                    #what command an alias is running
    get-alias -name %


##### get-alias

    get-alias –Definition Get-ChildItem   #definition parameter to get all aliases for a cmdlet
    get-alias -name ls                    #what command an alias is running
    get-alias -name %
    
##### Öffentliche IP anzeigen

    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    
##### PowerShell 2 auf PowerShell 3.0 aktualisieren (Windows 7)

    // In der cmd-Eingabeaufforderung:
    @powershell -NoProfile -ExecutionPolicy uneingeschränkt -Befehl "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%systemdrive% \chocolatey\bin cinst Powershell

##### Inhalt einer Datei löschen

   ```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```
##### Öffentliche IP anzeigen
   ```powershell
    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
    ```
##### Entspricht dem Linux-Befehl "tail".
   
    // Beendet die letzten 3 Zeilen der angegebenen Datei:
    Get-Content file-name-here -Tail 3
    
##### Äquivalent zu chmod 777 -R

    // Das '/t' steht für rekursiv
    cacls some_folder_here /t /e /g jeder:f
    
    // Neuer Weg
    // Das ':r' soll vorherige Berechtigungen entfernen
    icacls some_folder_here /grant:r Jeder:F /t

# Windows PowerShell-Cheatsheet

##### Get-Command & Get-Member
   ```powershell
    Get-Command                                           #like help in cmd 
    Get-Command | Sort-Object comand-type                 #sorted output
    Get-Command -Module hyper-v | Out-GridView            #show all hyper-v cmdlets

    Get-ChildItem | Get-Member                           #Eigenschaften this gets you everything
    Get-ChildItem | Get-Member -MemberType Property      #Eigenschaften
```

##### get-help
   ```powershell
    get-help Get-Process -Examples                       #Hilfe von einem Befehl
    get-help Get-Process -Online                         #Hilfe online
    get-help *-item                                      #Hilfe über alle Befehle mit *-item
    update-help                                          #Hilfe aktuallisieren
```

##### get-alias
   ```powershell
    get-alias –Definition Get-ChildItem                  #definition parameter to get all aliases for a cmdlet
    get-alias -name ls                                   #what command an alias is running
    get-alias -name %
```

##### /Process killen beenden
   ```powershell
Taskkill /T /F /IM bmd*                                  #beendet alle Prozesse mit bmd beginnend     
Taskkill /T /F /IM bmd.exe /bmd2.exe                     #beendet 2 bestimmte Prozesse
pskill -accepteula bmdntcs.exe                           #beendet bestimmten Prozesse
```

##### Dienst Beschreibung hinzufügen
   ```powershell
Set-Service -name BMDNTCSSOAPService221255 -Description "BMDNTCSSoapservice für 221255- läuft auf TCP Port 12640" #Dienst Beschreibung hinzfügen
 ```

##### network Ping
   ```powershell
    ping www.googel.at -force                                                                #ping in powershell
    while($true){Test-Connection 8.8.8.8}                                                    #permanent ping
    Test-NetConnection bmdntcstest2041                                                       #Ping with Boolean return
    1..254 | ForEach-Object 
    {Test-Connection -ComputerName "192.168.0.$_" -Count 1 -ErrorAction SilentlyContinue}    #IP Spoofing 1-254
    ipconfig /displaydns                                                                     #shows the dns
    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content                                 #show public ip
 ```
 
 ##### network Ping
   ```powershell
    Test-NetConnection -computer Computername -Port 89                  #Test Port
    dism /online /Enable-Feature /FeatureName:TelnetClient              # Telnet installieren
    New-Object System.Net.Sockets.TcpClient("192.168.0.24", 3389)       #alternative zu Telnet
    netstat -an |find /i "82"                                           # Port finden
    cmd telnet 192.168.0.24 3389                                        #Telnet verbindung
 ```
 
 ##### ReadHost
   ```powershell
    $adresse = Read-Host "Mail Adresse Eingeben: " #Read Host - List Eingabe in Variabe ein
 ```
 
 ##### network Ping
   ```powershell
    (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
 ```
     
#network Ping-----------------------------

#network Port-----------------------------
    dism /online /Enable-Feature /FeatureName:TelnetClient # Telnet installieren
    New-Object System.Net.Sockets.TcpClient("192.168.0.24", 3389)  #alternative zu Telnet
    netstat -an |find /i "82" # Port finden
    cmd telnet 192.168.0.24 3389 #Telnet verbindung
#network -----------------------------
    netsh.exe wlan show profiles name=’A1-morty-5G’ key=clear #Wlan SSID und Kennwort auslesen
    netsh wlan show networks #Wlan SSID auslesen
#regedit-----------------------------
    rename-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name "PendingFileRenameOperations" -NewName "_PendingFileRenameOperations" #PendingFileRenameOperations
#Entpacken-----------------------------    
    Invoke-WmiMethod -Path "Win32_Directory.Name='D:\test'" -name uncompress #dekomprimierung Ordner
#Bitlocker-----------------------------    
    get-WmiObject -Namespace "root\CIMV2\Security\MicrosoftVolumeEncryption" -Class Win32_EncryptableVolume | Sort-Object DriveLetter | out-file -filepath C:\Bitlocker.txt #Bitlocker Abfrage
#Export ico-----------------------------      
    Export-Icon C:\windows\system32\imageres.dll #shell32.dll #dsuiext.dll
#papierkorb-----------------------------      
    Clear-RecycleBin -Force #Papierkorb leeren
#helligkeit-----------------------------    
    (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,100) #Helligkeit 100 ist der Wert für die Helligkeit
#Akku %-----------------------------   
    Get-WmiObject win32_battery | Select-Object -expandProperty EstimatedChargeRemaining  #Akku Anzeige %
#RAM %-----------------------------   
    (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -expandProperty Capacity)/1GB #Ram Auslesen und auf GB umrechnen
#Color----------------------------- 
    Write-Host "Red " -ForegroundColor red -nonewline; Write-Host "black " -ForegroundColor black -nonewline;  Write-Host "Blue " -ForegroundColor blue; #ForegroundColor
#cmdlets-----------------------------
    regsvr32 „C:\Windows\midas.dll" #DLL registrieren
    net time \\bmdntcstest2041 #Systemzeit Auslesen
    dism.exe /online /enable-feature /featurename:NetFX3 /all /source:F:\sources\sxs #netFramework installieren



########################################################################################################################################
########################################################################################################################################
########################################################################################################################################



#while Übung-----
while (-not (Test-Path \\$alteVersion\d$\bmddemozip_backup\db-backup-fertig.txt)) {Start-Sleep -Milliseconds 100} #Wartet solange bis Backups fertig sind (anderes Skript erstellt db-backup-fertig.txt)

#remote-----------
schtasks /run /s bmd-admin /tn Speicherplatz_Testversion #Windows Task remote ausführen [führt die Aufgabe remote aus]

#exchange (Mail)--------
Get-mailbox | Get-MailboxFolderStatistics -FolderScope calendar | sort-object Name |ft Identity,Name #get-Mailbox

#Invoke-WebRequest-------
(Invoke-WebRequest -Uri "https://inspire.mindbreeze.com/de").Links.Href #get all Links from Site

#Invoke-Command------
Invoke-Command -ComputerName bmdntcstest2041 -ScriptBlock {get-date} #Systemzeit Auslesen
Get-CimInstance -ComputerName bmdntcstest2041 -ClassName Win32_LocalTime| Format-List Hour, Minute, Second -HideTableHeaders #Systemzeit Auslesen

#compare 2 folders-------
Compare-Object -ReferenceObject $path1 -DifferenceObject $path2 #Get-ChildItem -Recurse -path c:\test

#remote Schleife----------
$UserNames = ("bmdntcstest2041","bmdntcstest2045") #remote Schleife
ForEach ($User in $UserNames){Invoke-Command -ComputerName $User -ScriptBlock {query user} }  #remote Schleife



#____________________________________________________________________________________________________________________________________________________#
#Cred********************************************************************************************************************************************/#

######Eingabe von Benutzername und Passwort 
Get-Credential
$cred=Get-Credential

###################################################
#PSCredential-Object erzeugen und in eine Datei speichern
#Einige Cmdlets können das erzeugte PSCredential-Object direkt verwenden. Werden die Anmeldeinformationen mehrfach benötigt,
#können diese natürlich in einer Variable gespeichert werden, bzw. in eine Datei für einen späteren Aufruf:
#Authentication Passwort File generieren:

if (-not (Test-Path "$($env:Temp)\myapp_password.txt")) {
    $credential = Get-Credential
    $MyCredential.Password | ConvertFrom-SecureString | Set-Content "$($env:Temp)\myapp_password.txt"
}


#PSCredential-Object von Datei lesen
#Für das Erzeugen des PSCredential-Object aus einer Datei benötigen wir den Benutzernamen: Variable $user
$user = "mai156"
$Credential=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, (Get-Content "$($env:Temp)\myapp_password.txt" | ConvertTo-SecureString)


###################################################
#Passwort in eine Datei speichern
#Das Passwort kann auch direkt ohne "Get-Credential" in eine Datei gespeichert werden
"Sysmgr123!" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "$($env:Temp)\myApp_password2.txt"


$SecurePassword = Get-Content "$($env:Temp)\myApp_password.txt" | ConvertTo-SecureString
$UnsecurePassword = (New-Object PSCredential "mai156",$SecurePassword).GetNetworkCredential().Password

$MyCredential = $SecurePassword
#####
$User = "bmd-dom\mai156-admin"
$Password = "1234" | ConvertTo-SecureString -asPlainText -Force
$MyCredential = 1New-Object System.Management.Automation.PSCredential($User,$Password)

Start-Process -WindowStyle Hidden powershell.exe -Credential $MyCredential -ArgumentList '-noprofile -command &{Start c:\program\program.exe -Verb RunAs}'
Start-Process 'C:\Program Files (x86)\Notepad++\notepad++.exe' -Credential $MyCredential 

################################################
$MyCredential = Get-Credential
$MyCredential.Password | ConvertFrom-SecureString | Set-Content "$($env:Temp)\myapp_password.txt"
$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "bmd-dom\mai156-admin", (Get-Content "$($env:Temp)\myapp_password.txt" | ConvertTo-SecureString)
Start-Process 'D:\powershell\_exe\Speicherplatz_Testversion.exe' -Credential $MyCredential 


################################################
$MyCredential=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "bmd-dom\mai156-admin", (Get-Content "$($env:Temp)\myapp_password.txt" | ConvertTo-SecureString)
Start-Process C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell_ise_Admin.exe -Credential $MyCredential

#Ende********************************************************************************************************************************************/#
 
 
 
 
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

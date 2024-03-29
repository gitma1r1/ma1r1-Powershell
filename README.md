##### Chapter 0 - other Powershell GIT Cheatsheet
> - https://gist.github.com/pcgeek86/336e08d1a09e3dd1a8f0a30a9fe61c8a#file-cheatsheet-ps1
> - https://github.com/ab14jain/PowerShell

## Windows PowerShell-Cheatsheet

##### Chapter 1 - Powershell simple

   ```powershell

   # Get-Command Example
   Get-Command                                          #like help in cmd 
   Get-Command | Sort-Object comand-type                #sorted output
   Get-Command -Module hyper-v | Out-GridView           #show all hyper-v cmdlets

   #Get-Member Example
   Get-ChildItem | Get-Member                           #Eigenschaften this gets you everything
   Get-ChildItem | Get-Member -MemberType Property      #Eigenschaften

   #get-help Example
   get-help Get-Process -Examples                       #Hilfe von einem Befehl
   get-help Get-Process -Online                         #Hilfe online
   get-help *-item                                      #Hilfe über alle Befehle mit *-item
   update-help                                          #Hilfe aktuallisieren

   #get-alias Example
   get-alias –Definition Get-ChildItem                  #definition parameter to get all aliases for a cmdlet
   get-alias -name ls                                   #what command an alias is running
   get-alias -name %

   #Read-Host Example
   $adresse = Read-Host "Mail Adresse Eingeben: " #Read Host - List Eingabe in Variabe ein

   # Write-Host Example
   Write-Host "Red " -ForegroundColor red -nonewline; Write-Host "black " -ForegroundColor black -nonewline;  Write-Host "Blue " -ForegroundColor blue; #ForegroundColor

   #Install a Module example
   Install-Module -Name "ISESteroids" -Scope CurrentUser -Repository PSGallery -Force   #Install Module: ISESterioids
   Start-Steroids

   #Import a Module example 
   Import-Module NTFSSecurity 
   add-ntfsaccess -path D:\temp\ -Account domain\Domänen-Benutzer -AccessRights ReadandExecute #ReadandExecute , Modify

   #Dienst Beschreibung hinzufügen
   Set-Service -name BMDNTCSSOAPService221255 -Description "BMDNTCSSoapservice für 221255- läuft auf TCP Port 12640" #Dienst Beschreibung hinzfügen

   #Regedit File umbenennen
   rename-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name "PendingFileRenameOperations" -NewName "_PendingFileRenameOperations" #PendingFileRenameOperations

   #/Process killen beenden
   Taskkill /T /F /IM bmd*                               #beendet alle Prozesse mit bmd beginnend     
   Taskkill /T /F /IM bmd.exe /bmd2.exe                  #beendet 2 bestimmte Prozesse
   pskill -accepteula bmdntcs.exe                        #beendet bestimmten Prozesse

   #Powerhsell Version auslesen
   $PowershellVersion = ($PSVersionTable).PSVersion | Select-Object major -ExpandProperty major #Powershell Version
   Write-Host "Powershell Version: $PowershellVersion" 

```

##### Chapter 2 - Powershell - Network
   ```powershell

   #Network Ping

   #ping in powershell
   ping www.googel.at -force                                                                #ping in powershell

   #permanent ping
   while($true){Test-Connection 8.8.8.8}                                                    #permanent ping

   #Ping with Boolean return
   Test-NetConnection bmdntcstest2041                                                       #Ping with Boolean return
   1..254 | ForEach-Object 

   #IP Spoofing 1-254
   {Test-Connection -ComputerName "192.168.0.$_" -Count 1 -ErrorAction SilentlyContinue}    #IP Spoofing 1-254

   #shows the dns
   ipconfig /displaydns                                                                     #shows the dns

   #show public ip
   (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content                                 #show public ip
 
   #Network Port

   #Test Port
   Test-NetConnection -computer Computername -Port 89                  #Test Port

   #Telnet via dism installieren
   dism /online /Enable-Feature /FeatureName:TelnetClient              #Telnet installieren

   #alternative zu telnet
   New-Object System.Net.Sockets.TcpClient("192.168.0.24", 3389)       #alternative zu Telnet

   #Port finden locoal
   netstat -an |find /i "82"                                           #Port finden

   #telnet via powershell
   cmd telnet 192.168.0.24 3389                                        #Telnet verbindung

   #Port scan (slow version)
   foreach ($port in 1..104) {If (($a=Test-NetConnection srvfs01 -Port $port -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true){ "TCP port $port is open!"}}

   # Network stuff

   #Wlan SSID und Kennwort auslesen
   netsh.exe wlan show profiles name=’A1-morty-5G’ key=clear           #Wlan SSID und Kennwort auslesen

   #Wlan SSID auslesen
   netsh wlan show networks                                            #Wlan SSID auslesen

 ```
 
 
   ##### Chapter 3 - SQL Befehle
   ```powershell

   #SQL Script starten via sqlcmd
   sqlcmd -E -S instanz\db -i C:\temp\skript.sql  #starts a sql skript invoke


 ```

##### Chapter 4 - Exchange 
   ```powershell

#Import Exchange Module (Snapin)
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn #Snapin Exchange 

#get Aliasadresse
get-mailbox -OrganizationalUnit "OU=206090,OU=AT,OU=ASP-Kunden,DC=Asp01dom,DC=local" | select Name,SamAccountName -ExpandProperty EmailAddresses | select Name,SamAccountName,SMTPAddress | sort samaccountname | export-scv d:\temp\adresses.csv

#get Exchange all Adress + Alias
Get-Mailbox -ResultSize Unlimited -OrganizationalUnit "OU=211759,OU=AT,OU=ASP-Kunden,DC=Asp01dom,DC=local" | Select DisplayName,PrimarySmtpAddress, @{Name="EmailAddresses";Expression={($_.EmailAddresses | Where-Object {$_ -clike "smtp*"} | ForEach-Object {$_ -replace "smtp:",""}) -join ","}} | Sort-Object DisplayName | export-csv '\\ASP-Admin\D$\UserPST\Temp\testsss.csv' -Delimiter ";" -NoType -Encoding UTF8  

#Mailboxen mit Weiterleitung (Forward)
Get-Mailbox -OrganizationalUnit "OU=206090,OU=AT,OU=ASP-Kunden,DC=Asp01dom,DC=local" | Where {$_.ForwardingAddress -ne $null} | Select Name, Alias, ForwardingAddress, DeliverToMailboxAndForward

#Mailboxsize
Get-Mailbox -OrganizationalUnit "OU=203962,OU=AT,OU=ASP-Kunden,DC=Asp01dom,DC=local" -ResultSize Unlimited | Get-MailboxStatistics | Sort-Object TotalItemSize -Descending | Select-Object DisplayName,Alias,TotalItem
```

 
  ##### Chapter 5 - Windows Stuff
   ```powershell

   #Energieeinstellungen
   powercfg -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c           #Höchstleistung
   powercfg -SETACTIVE 381b4222-f694-41f0-9685-ff5bb260df2e           #Ausbalanciert
   powercfg -SETACTIVE a1841308-3541-4fab-bc81-f71556f20b4a           #Energiesparmodus

   #Speicherplatz C:\Windows
   DISM.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase 

   #Papierkorb leeren
   Clear-RecycleBin -Force                                            #Papierkorb leeren

   #Netlaufwerk Force entfernen
   Remove-SmbMapping -RemotePath \\server\share -LocalPath Z: -Force  #remove SMBShare

   #Helligkeit setzen
   (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,100) #Helligkeit 100 ist der Wert für die Helligkeit

   #Akku Status anzeigen
   Get-WmiObject win32_battery | Select-Object -expandProperty EstimatedChargeRemaining           #Akku Anzeige %

   #Ram auslesen in GB
   (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -expandProperty Capacity)/1GB        #Ram Auslesen und auf GB umrechnen

   #Icons aus dll exportieren
   Export-Icon C:\windows\system32\imageres.dll                                                   #export ico example:shell32.dll #dsuiext.dll
   
   #Install Google Chrome
   $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); &          "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running:    $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound) #Install Google Chrome
   
 ```

   ##### Chapter 6 - Examples
 
   ##### Check if the correct IP Syntax is returned
   ```powershell
$input8 = "192.168.1.11"
$Octet = '(?:0?0?[0-9]|0?[1-9][0-9]|1[0-9]{2}|2[0-5][0-5]|2[0-4][0-9])' #matches 0-255, and not higher than 255
[regex] $IPv4Regex = "^(?:$Octet\.){3}$Octet$" #match an actual IP address instead of a number between 0 and 255 on its own
'1.10.100.0' -match $IPv4Regex #Check
if ("$input8" -match $IPv4Regex){
[System.Windows.Forms.MessageBox]::Show("Correct IP syntax...")
}else{
[System.Windows.Forms.MessageBox]::Show("wronge IP syntax...")
}
 ```
 
 






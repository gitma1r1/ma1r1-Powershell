# PowerShell

> **other Powershell GIT Cheatsheet**
> - https://gist.github.com/pcgeek86/336e08d1a09e3dd1a8f0a30a9fe61c8a#file-cheatsheet-ps1
> - https://github.com/ab14jain/PowerShell

## Windows PowerShell-Cheatsheet

##### Get-Command & Get-Member
   ```powershell
   Get-Command                                          #like help in cmd 
   Get-Command | Sort-Object comand-type                #sorted output
   Get-Command -Module hyper-v | Out-GridView           #show all hyper-v cmdlets

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
  Taskkill /T /F /IM bmd*                               #beendet alle Prozesse mit bmd beginnend     
  Taskkill /T /F /IM bmd.exe /bmd2.exe                  #beendet 2 bestimmte Prozesse
  pskill -accepteula bmdntcs.exe                        #beendet bestimmten Prozesse
```

##### Dienst Beschreibung hinzufügen
   ```powershell
  Set-Service -name BMDNTCSSOAPService221255 -Description "BMDNTCSSoapservice für 221255- läuft auf TCP Port 12640" #Dienst Beschreibung hinzfügen
 ```
 
 ##### Install Module - (Source: http://www.powertheshell.com/)
   ```powershell
  Install-Module -Name "ISESteroids" -Scope CurrentUser -Repository PSGallery -Force   #Install Module: ISESterioids
  Start-Steroids
    
  Import-Module NTFSSecurity 
  add-ntfsaccess -path D:\temp\ -Account domain\Domänen-Benutzer -AccessRights ReadandExecute #ReadandExecute , Modify
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
 
 ##### network Port
   ```powershell
   Test-NetConnection -computer Computername -Port 89                  #Test Port
    
   dism /online /Enable-Feature /FeatureName:TelnetClient              #Telnet installieren
    
   New-Object System.Net.Sockets.TcpClient("192.168.0.24", 3389)       #alternative zu Telnet
    
   netstat -an |find /i "82"                                           #Port finden
    
   cmd telnet 192.168.0.24 3389                                        #Telnet verbindung
 ```
 
  ##### network stuff
   ```powershell
  netsh.exe wlan show profiles name=’A1-morty-5G’ key=clear           #Wlan SSID und Kennwort auslesen
    
  netsh wlan show networks                                            #Wlan SSID auslesen
 ```
 
  ##### rename regedit File
   ```powershell
   rename-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name "PendingFileRenameOperations" -NewName "_PendingFileRenameOperations" #PendingFileRenameOperations
 ```
 
   ##### SQL 
   ```powershell
sqlcmd -E -S instanz\db -i C:\temp\skript.sql  #starts a sql skript invoke
 ```
 
  ##### Windows Stuff
   ```powershell
   
   powercfg -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c           #Höchstleistung
   powercfg -SETACTIVE 381b4222-f694-41f0-9685-ff5bb260df2e           #Ausbalanciert
   powercfg -SETACTIVE a1841308-3541-4fab-bc81-f71556f20b4a           #Energiesparmodus

   Clear-RecycleBin -Force                                            #Papierkorb leeren

   (Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,100) #Helligkeit 100 ist der Wert für die Helligkeit

   Get-WmiObject win32_battery | Select-Object -expandProperty EstimatedChargeRemaining           #Akku Anzeige %
    
  (Get-WmiObject -Class Win32_PhysicalMemory | Select-Object -expandProperty Capacity)/1GB        #Ram Auslesen und auf GB umrechnen

   Export-Icon C:\windows\system32\imageres.dll                                                   #export ico example:shell32.dll #dsuiext.dll
   
#Install Google Chrome
$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound) #Install Google Chrome
   
 ```
 
  ##### Get the antivirus product 
   ```powershell
$Virenscanners = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct
            foreach($Virenscanner in $Virenscanners){
                $antivirusProduct += $Virenscanner.displayName

$wmiQuery_avp = "SELECT * FROM AntiVirusProduct" 
$AntivirusProduct_ = Get-WmiObject -Namespace "root\SecurityCenter2" -Query $wmiQuery_avp  @psboundparameters -ErrorVariable myError -ErrorAction 'SilentlyContinue'   $antivirusProduct = $AntivirusProduct_.displayName

(Get-MpComputerStatus).AntivirusProduct
 ```
 
 ##### Check if SQL Server is installed
   ```powershell
        $sqlServerInstalled = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Microsoft SQL Server" -ErrorAction SilentlyContinue
        if ($sqlServerInstalled) {
            $sqlServerInstalled_String = "SQL Server is installed on this machine"

            #Get installed SQL Versions
            $SQLVersion_regs = (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
            foreach ($SQLVersion_reg in $SQLVersion_regs){
               $SQLVersion_ = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$SQLVersion_reg
               $SQLVersion_main = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$SQLVersion_\Setup").Edition
               $SQLVersion_sub = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$SQLVersion_\Setup").Version
            }
        } else {
            $sqlServerInstalled_String = "SQL Server is not installed on this machine"
        }
 ```

 ##### ReadHost / Write-Host
   ```powershell
   $adresse = Read-Host "Mail Adresse Eingeben: " #Read Host - List Eingabe in Variabe ein
    
   Write-Host "Red " -ForegroundColor red -nonewline; Write-Host "black " -ForegroundColor black -nonewline;  Write-Host "Blue " -ForegroundColor blue; #ForegroundColor
 ```
 
##### Powerhsell Version
   ```powershell
$PowershellVersion = ($PSVersionTable).PSVersion | Select-Object major -ExpandProperty major #Powershell Version
Write-Host "Powershell Version: $PowershellVersion" 
```

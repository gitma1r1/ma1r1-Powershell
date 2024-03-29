##### Chapter 0 - other Powershell GIT Cheatsheet
> - https://gist.github.com/pcgeek86/336e08d1a09e3dd1a8f0a30a9fe61c8a#file-cheatsheet-ps1
> - https://github.com/ab14jain/PowerShell

## Windows PowerShell-Cheatsheet

##### Chapter 1 - Powershell simple

   ```powershell

   # Get-Command Example
   Get-Command                                          #like help in cmd
   Get-Command -Module Microsoft*                       # Retrieves a list of all the modules named Microsoft*
   Get-Command -Name *item                              # Retrieves a list of all commands ending in "item"
   Get-Command | Sort-Object comand-type                #sorted output
   Get-Command -Module hyper-v | Out-GridView           #show all hyper-v cmdlets
   Get-Command -All                                     all commands

   #Get-Member Example
   Get-ChildItem | Get-Member                           #Eigenschaften this gets you everything
   Get-ChildItem | Get-Member -MemberType Property      #Eigenschaften

   #CMD command in powershell
   cmd.exe /c dir                                       #cmd-Aufruf via Powershell

   #Get-Host
   Get-Host                                             #get the Host details

   #Bildschirm "leeren"
   Clear-Host                                           # same as cls in CMD; clears the screen
   cls

   #$env
   $env:COMPUTERNAME                                    # Computername
   $env:USERNAME                                        # USERNAME
   $env:USERDNSDOMAIN                                   # USERDNSDOMAIN
#NOTE: If you dont know all the variables part of it, after : type tab key to all those variables one-by-one.

   #get-help Example
   Get-Help                                             # Get all help topics
   Get-help Get-Process -Examples                       #Hilfe von einem Befehl
   Get-help Get-Process -Online                         #Hilfe online
   Get-help *-item                                      #Hilfe über alle Befehle mit *-item
   Update-help                                          #Hilfe aktuallisieren
   Get-Help -Name about_Variables                       # a specific about_* topic (aka. man page)
   Get-Help -Name Get-Command                           # a specific PowerShell function
   Get-Help -Name Get-Command -Parameter Module         # a specific parameter on a specific command

   #get-alias Example
   get-alias –Definition Get-ChildItem                  #definition parameter to get all aliases for a cmdlet
   get-alias -name ls                                   #what command an alias is running
   get-alias -name %

   #a list of verbs
   Get-Verb                                             #get the list of approved verbs

   #Get-History
   Get-History                                       #Get-History Powershell commands

   #Read-Host Example
   $adresse = Read-Host "Mail Adresse Eingeben: " #Read Host - List Eingabe in Variabe ein

   # Write-Host Example
   Write-Host "Red " -ForegroundColor red -nonewline; Write-Host "black " -ForegroundColor black -nonewline;      Write-Host "Blue " -ForegroundColor blue; #ForegroundColor

###################################################
# Operators
###################################################

   $a = 2                                              # Basic variable assignment operator
   $a += 1                                             # Incremental assignment operator
   $a -= 1                                             # Decrement assignment operator

   $a -eq 0                                            # Equality comparison operator
   $a -ne 5                                            # Not-equal comparison operator
   $a -gt 2                                            # Greater than comparison operator
   $a -lt 3                                            # Less than comparison operator

   $FirstName = 'Trevor'
   $FirstName -like 'T*'                               # Perform string comparison using the -like operator, which supports the wildcard (*) character. Returns $true
   
   $BaconIsYummy = $true
   $FoodToEat = $BaconIsYummy ? 'bacon' : 'beets'      # Sets the $FoodToEat variable to 'bacon' using the ternary operator
   
   'Celery' -in @('Bacon', 'Sausage', 'Steak', 'Chicken')    # Returns boolean value indicating if left-hand operand exists in right-hand array
   'Celery' -notin @('Bacon', 'Sausage', 'Steak')            # Returns $true, because Celery is not part of the right-hand list
   
   5 -is [string]                                            # Is the number 5 a string value? No. Returns $false.
   5 -is [int32]                                             # Is the number 5 a 32-bit integer? Yes. Returns $true.
   5 -is [int64]                                             # Is the number 5 a 64-bit integer? No. Returns $false.
   'Trevor' -is [int64]                                      # Is 'Trevor' a 64-bit integer? No. Returns $false.
   'Trevor' -isnot [string]                                  # Is 'Trevor' NOT a string? No. Returns $false.
   'Trevor' -is [string]                                     # Is 'Trevor' a string? Yes. Returns $true.
   $true -is [bool]                                          # Is $true a boolean value? Yes. Returns $true.
   $false -is [bool]                                         # Is $false a boolean value? Yes. Returns $true.
   5 -is [bool]                                              # Is the number 5 a boolean value? No. Returns $false.

###################################################
# Regular Expressions
###################################################

'Trevor' -match '^T\w*'                                   # Perform a regular expression match against a string value. # Returns $true and populates $matches variable
$matches[0]                                               # Returns 'Trevor', based on the above match

@('Trevor', 'Billy', 'Bobby') -match '^B'                 # Perform a regular expression match against an array of string values. Returns Billy, Bobby

$regex = [regex]'(\w{3,8})'
$regex.Matches('Trevor Bobby Dillon Joe Jacob').Value     # Find multiple matches against a singleton string value.

###################################################
# Flow Control
###################################################

if (1 -eq 1) { }                                          # Do something if 1 is equal to 1

do { 'hi' } while ($false)                                # Loop while a condition is true (always executes at least once)

while ($false) { 'hi' }                                   # While loops are not guaranteed to run at least once
while ($true) { }                                         # Do something indefinitely
while ($true) { if (1 -eq 1) { break } }                  # Break out of an infinite while loop conditionally

for ($i = 0; $i -le 10; $i++) { Write-Host $i }           # Iterate using a for..loop
foreach ($item in (Get-Process)) { }                      # Iterate over items in an array

switch ('test') { 'test' { 'matched'; break } }           # Use the switch statement to perform actions based on conditions. Returns string 'matched'
switch -regex (@('Trevor', 'Daniel', 'Bobby')) {          # Use the switch statement with regular expressions to match inputs
  'o' { $PSItem; break }                                  # NOTE: $PSItem or $_ refers to the "current" item being matched in the array
}
switch -regex (@('Trevor', 'Daniel', 'Bobby')) {          # Switch statement omitting the break statement. Inputs can be matched multiple times, in this scenario.
  'e' { $PSItem }
  'r' { $PSItem }
}

###################################################
# Variables
###################################################


$a = 0                                                    # Initialize a variable
[int] $a = 'Trevor'                                       # Initialize a variable, with the specified type (throws an exception)
[string] $a = 'Trevor'                                    # Initialize a variable, with the specified type (doesn't throw an exception)

Get-Command -Name *varia*                                 # Get a list of commands related to variable management

Get-Variable                                              # Get an array of objects, representing the variables in the current and parent scopes 
Get-Variable | ? { $PSItem.Options -contains 'constant' } # Get variables with the "Constant" option set
Get-Variable | ? { $PSItem.Options -contains 'readonly' } # Get variables with the "ReadOnly" option set

New-Variable -Name FirstName -Value Trevor
New-Variable FirstName -Value Trevor -Option Constant     # Create a constant variable, that can only be removed by restarting PowerShell
New-Variable FirstName -Value Trevor -Option ReadOnly     # Create a variable that can only be removed by specifying the -Force parameter on Remove-Variable

Remove-Variable -Name firstname                           # Remove a variable, with the specified name
Remove-Variable -Name firstname -Force                    # Remove a variable, with the specified name, that has the "ReadOnly" option set

###################################################
# Functions
###################################################

function add ($a, $b) { $a + $b }                         # A basic PowerShell function

function Do-Something {                                   # A PowerShell Advanced Function, with all three blocks declared: BEGIN, PROCESS, END
  [CmdletBinding]()]
  param ()
  begin { }
  process { }
  end { }
}

###################################################
# Working with Modules
###################################################

Get-Command -Name *module* -Module mic*core                 # Which commands can I use to work with modules?

Get-Module -ListAvailable                                   # Show me all of the modules installed on my system (controlled by $env:PSModulePath)
Get-Module                                                  # Show me all of the modules imported into the current session

$PSModuleAutoLoadingPreference = 0                          # Disable auto-loading of installed PowerShell modules, when a command is invoked

Import-Module -Name NameIT                                  # Explicitly import a module, from the specified filesystem path or name (must be present in $env:PSModulePath)
Remove-Module -Name NameIT                                  # Remove a module from the scope of the current PowerShell session

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

###################################################
# PowerShell Drives (PSDrives)
###################################################

Get-PSDrive                                                 # List all the PSDrives on the system
New-PSDrive -Name videos -PSProvider Filesystem -Root x:\data\content\videos  # Create a new PSDrive that points to a filesystem location
New-PSDrive -Name h -PSProvider FileSystem -Root '\\storage\h$\data' -Persist # Create a persistent mount on a drive letter, visible in Windows Explorer
Set-Location -Path videos:                                  # Switch into PSDrive context
Remove-PSDrive -Name xyz                                    # Delete a PSDrive

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

Get-CimInstance -ClassName Win32_BIOS                       # Retrieve BIOS information
Get-CimInstance -ClassName Win32_DiskDrive                  # Retrieve information about locally connected physical disk devices
Get-CimInstance -ClassName Win32_PhysicalMemory             # Retrieve information about install physical memory (RAM)
Get-CimInstance -ClassName Win32_NetworkAdapter             # Retrieve information about installed network adapters (physical + virtual)
Get-CimInstance -ClassName Win32_VideoController            # Retrieve information about installed graphics / video card (GPU)

Get-CimClass -Namespace root\cimv2                          # Explore the various WMI classes available in the root\cimv2 namespace
Get-CimInstance -Namespace root -ClassName __NAMESPACE      # Explore the child WMI namespaces underneath the root\cimv2 namespace
   
   #Install Google Chrome
   $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); &          "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running:    $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound) #Install Google Chrome



 ```

   ##### Chapter 6 - Examples
 
   ##### Check if the correct IP Syntax is returned
   ```powershell
#Check if the correct IP Syntax is returned
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

   ##### Skript Break - WaitForTextFile Function
   ```powershell
#Skript Break - WaitForTextFile Function
function WaitForTextFile {
    param([string]$PathToFile)

    # Überprüfen, ob die Datei vorhanden ist
    while (-not (Test-Path $PathToFile)) {
        Write-Host "Warte auf Datei: $PathToFile" -ForegroundColor Yellow
        Start-Sleep -Milliseconds 1000
    }

    $currentTime = Get-Date
    Write-Host "Datei gefunden: $PathToFile" -ForegroundColor Green
    Write-Host "Datum und Uhrzeit: $currentTime" -ForegroundColor Green
}

# Beispielaufruf der Funktion
WaitForTextFile -PathToFile "D:\tmp\test.txt"

 ```


 
 






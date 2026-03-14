function Test-PortConnections {
 param (
     [string[]]$TargetHosts = @("localhost"),
     [int[]]$Ports = @(80),
     [int]$PortRangeStart,
     [int]$PortRangeEnd,
     [int]$Timeout = 250,
     [int]$Interval = 3,
     [int]$Count = -1,
     [switch]$Ping,
     [string]$Subnet = "",
     [int]$StartRange = 1,
     [int]$EndRange = 254,
     [switch]$prioPort
 )

 # Validierung der Eingabewerte
 if ($Ports -and ($Ports -lt 1 -or $Ports -gt 65535)) {
     throw "Ports müssen zwischen 1 und 65535 liegen."
 }

 if ($PortRangeStart -or $PortRangeEnd) {
     if ($PortRangeStart -lt 1 -or $PortRangeStart -gt 65535) {
         throw "PortRangeStart muss zwischen 1 und 65535 liegen."
     }
     if ($PortRangeEnd -lt 1 -or $PortRangeEnd -gt 65535) {
         throw "PortRangeEnd muss zwischen 1 und 65535 liegen."
     }
     if ($PortRangeStart -gt $PortRangeEnd) {
         throw "PortRangeStart muss kleiner oder gleich PortRangeEnd sein."
     }
 }

 if ($Timeout -lt 0) {
     throw "Timeout muss eine positive Ganzzahl sein."
 }

 if ($StartRange -lt 1 -or $EndRange -gt 254 -or $StartRange -gt $EndRange) {
     throw "StartRange muss zwischen 1 und 254 liegen und kleiner oder gleich EndRange sein."
 }

 # Erstelle eine Liste von Ports, falls ein Bereich angegeben wurde
 $PortList = @()
 if ($PortRangeStart -and $PortRangeEnd) {
     $PortList += $PortRangeStart..$PortRangeEnd
 }
 if ($Ports) {
     $PortList += $Ports
 }
 $PortList = $PortList | Select-Object -Unique | Sort-Object

 if ($Subnet) {
     $TargetHosts = @()
     $StartRange..$EndRange | ForEach-Object {
         $TargetHosts += "$Subnet.$_"
     }
 }

 $currentIteration = 0
 $successCount = 0
 $failureCount = 0

 # Ausgabe der Überschrift
 Write-Host "---------------------------------------------------" -ForegroundColor Cyan
 Write-Host " Zeitstempel           | Host/IP             | Port | Status         | Latenz (ms)" -ForegroundColor Yellow
 Write-Host "---------------------------------------------------"

 while ($Count -eq -1 -or $currentIteration -lt $Count) {
     if ($prioPort) {
         foreach ($Port in $PortList) {
             foreach ($TargetHost in $TargetHosts) {
                 $result = Test-HostPortConnection -TargetHost $TargetHost -Port $Port -Ping:$Ping -Timeout $Timeout
                 if ($result.Status) {
                     $successCount++
                 } else {
                     $failureCount++
                 }
             }
         }
     } else {
         foreach ($TargetHost in $TargetHosts) {
             foreach ($Port in $PortList) {
                 $result = Test-HostPortConnection -TargetHost $TargetHost -Port $Port -Ping:$Ping -Timeout $Timeout
                 if ($result.Status) {
                     $successCount++
                 } else {
                     $failureCount++
                 }
             }
         }
     }

     $currentIteration++

     # Ausgabe einer Leerzeile nach jeder Abfragerunde, wenn Count > 1 oder kein Count angegeben
     if ($Count -ne 1) {
         Write-Host ""  # Leerzeile
     }

     Start-Sleep -Seconds $Interval
 }

 # Ausgabe der Zusammenfassung
 Write-Host "---------------------------------------------------" -ForegroundColor Cyan
 Write-Host "Tests abgeschlossen: Erfolgreich: $successCount, Fehlgeschlagen: $failureCount" -ForegroundColor Yellow
}

function Test-HostPortConnection {
 param (
     [string]$TargetHost,
     [int]$Port,
     [switch]$Ping,
     [int]$Timeout
 )

 try {
     $ResolvedIPs = if ($TargetHost -match '\d{1,3}(\.\d{1,3}){3}') {
         $TargetHost
     } else {
         [System.Net.Dns]::GetHostAddresses($TargetHost) | Select-Object -First 1
     }
 } catch {
     Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Fehler bei der DNS-Auflösung für $TargetHost." -ForegroundColor Red
     return @{ Status = $false }
 }

 if ($Ping) {
     $pingResult = Test-Connection -ComputerName $TargetHost -Count 1 -ErrorAction SilentlyContinue
     if ($pingResult) {
         $output = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: N/A | Status: Ping erfolgreich | Latenz: $($pingResult.ResponseTime) ms"
         Write-Host $output -ForegroundColor Green
         return @{ Status = $true }
     } else {
         Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: N/A | Status: Ping fehlgeschlagen" -ForegroundColor Red
         return @{ Status = $false }
     }
 } else {
     $TCPClient = [System.Net.Sockets.TcpClient]::new()
     $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
     
     try {
         $Result = $TCPClient.ConnectAsync($ResolvedIPs, $Port).Wait($Timeout)
         $Stopwatch.Stop()
         $Latency = $Stopwatch.ElapsedMilliseconds
         
         if ($Result) {
             $output = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: $Port | Status: Erfolgreich | Latenz: $Latency ms"
             Write-Host $output -ForegroundColor Green
             return @{ Status = $true }
         } else {
             Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: $Port | Status: Fehlgeschlagen" -ForegroundColor Red
             return @{ Status = $false }
         }
     } catch [System.Net.Sockets.SocketException] {
         if ($_.Exception.SocketErrorCode -eq [System.Net.Sockets.SocketError]::ConnectionRefused) {
             Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: $Port | Status: Verbindung abgelehnt" -ForegroundColor Red
         } elseif ($_.Exception.SocketErrorCode -eq [System.Net.Sockets.SocketError]::TimedOut) {
             Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: $Port | Status: Zeitüberschreitung" -ForegroundColor Red
         } else {
             Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $TargetHost ($ResolvedIPs) | Port: $Port | Status: Fehler - $($_.Exception.Message)" -ForegroundColor Red
         }
         return @{ Status = $false }
     } finally {
         $TCPClient.Close()
     }
 }
}

# Beispiel-Aufrufe:
##Einfach
# Single TargetHost - Single Port - Test: Ping
 Test-PortConnections -TargetHosts @("orf.at") -Ports @(80) -Ping -Count 1
# Single TargetHost - Single Port - Test: Port
 Test-PortConnections -TargetHosts @("orf.at") -Ports @(80) -Count 1
# Multi TargetHosts - Single Port - Test: Ports
 Test-PortConnections -TargetHosts @("192.168.0.1","orf.at","192.167.0.1") -Ports @(80) -Count 1
# Multi TargetHosts - Multi Port - prio IP
 Test-PortConnections -TargetHosts @("192.168.0.1","orf.at","192.167.0.1") -Ports @(22,80,443) -Count 1
# Multi TargetHosts - Multi Port - prio Port
 Test-PortConnections -TargetHosts @("192.168.0.1","orf.at","192.167.0.1") -Ports @(22,80,443) -prioPort -Count 1

##Subnet
# SubNet Target - - Test: Ping
 Test-PortConnections -Subnet "10.22.40" -StartRange 1 -EndRange 254 -Count 1 -Ping
# SubNet Target - Single Port - prio IP
 Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Ports @(80) -prioPort -Count 1
# SubNet Target - Multi Port - prio Port
 Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Ports @(80,443) -prioPort -Count 1

##Port Range
# Single TargetHosts - Port Range - Test: Ports
 Test-PortConnections -TargetHosts @("80.121.194.193") -PortRangeStart 20 -PortRangeEnd 25 -prioPort -Count 1
# Single TargetHosts - Multi Ports + Port Range - Test: Ports
 Test-PortConnections -TargetHosts @("80.121.194.193") -Ports @(22,80,443,8000,8123) -PortRangeStart 20 -PortRangeEnd 25 -prioPort -Count 1
# Multi TargetHosts - Multi Ports + Port Range - Test: Ports
 Test-PortConnections -TargetHosts @("10.250.251.11","10.250.251.12","10.250.251.13","orf.at","asp-dms-stable") -Ports @(22,80,81,86,443,8080,8443) -PortRangeStart 30464 -PortRangeEnd 30470 -prioPort -Count 1
# SubNet Target - Port Range
 Test-PortConnections -Subnet "10.250.251" -StartRange 1 -EndRange 254 -PortRangeStart 30464 -PortRangeEnd 30470 -Count 1




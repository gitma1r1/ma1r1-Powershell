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


# Beispiel-Aufruf Single IP Single Port (like tnc)
# Test-PortConnections -TargetHosts @("orf.at") -Ports @(80) -Count 1

# Beispiel-Aufruf der Funktion mit multi TargetHosts und multi Ports
# Test-PortConnections -TargetHosts @("192.168.0.1","orf.at","192.167.0.1") -Ports @(22,80,443) -Count 1

# Beispiel-Aufruf der Funktion mit prioPort (ports)
# Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Ports @(80,443) -prioPort -Count 1

# Beispiel-Aufruf der Funktion mit prioPort (ports) + PortRange
# Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Ports @(80,443) -PortRangeStart 5000 -PortRangeEnd 5100 -prioPort -Count 1

# Beispiel-Aufruf der Funktion mit Ping IPRange
# Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Count 1 -Ping
# Test-PortConnections -TargetHosts @("orf.at") -Ping -Count 1
# Test-PortConnections -TargetHosts @("192.168.10.111") -Ping -Count 1
# Test-PortConnections -TargetHosts @("172.19.19.11","orf.at") -Ping -count 3

function Test-PortConnections {
    param (
        [string[]]$TargetHosts = @("prtg.bmd.at"),  # Liste von Hosts als Array
        [int[]]$Ports = @(80),                      # Liste der Ports als Array, Standard ist Port 80
        [int]$PortRangeStart,                       # Optionaler Start des Portbereichs
        [int]$PortRangeEnd,                         # Optionales Ende des Portbereichs
        [int]$Timeout = 250,                        # Timeout in Millisekunden
        [int]$Interval = 3,                         # Intervall zwischen den Abfragen in Sekunden
        [int]$Count = -1,                           # Anzahl der Durchläufe, Standard ist unendlich (-1)
        [switch]$Ping,                              # Aktiviert die ICMP-Ping-Option
        [string]$Subnet = "",                       # Subnet für IP-Range, optional
        [int]$StartRange = 1,                       # Start der IP-Range, optional
        [int]$EndRange = 254,                       # Ende der IP-Range, optional
        [switch]$prioPort                           # Schalter, um Priorität auf Ports oder IPs zu legen
    )

    # Erstelle eine Liste von Ports, falls ein Bereich angegeben wurde
    $PortList = @()

    if ($PortRangeStart -and $PortRangeEnd) {
        $PortList += $PortRangeStart..$PortRangeEnd
    }

    # Füge die spezifischen Ports hinzu
    if ($Ports) {
        $PortList += $Ports
    }

    # Entferne doppelte Ports und sortiere die Liste
    $PortList = $PortList | Select-Object -Unique | Sort-Object

    $currentIteration = 0  # Zähler für die Anzahl der Durchläufe

    # Falls eine Subnet-Range angegeben wurde, füge die IP-Adressen der Hosts-Liste hinzu
    if ($Subnet) {
        $TargetHosts = @()
        $StartRange..$EndRange | ForEach-Object {
            $TargetHosts += "$Subnet.$_"
        }
    }

    while ($Count -eq -1 -or $currentIteration -lt $Count) {
        if ($prioPort) {
            # Priorität auf Ports, also erst alle IPs für einen Port durchgehen
            foreach ($Port in $PortList) {
                foreach ($TargetHost in $TargetHosts) {
                    Test-HostPortConnection -TargetHost $TargetHost -Port $Port -Ping:$Ping -Timeout $Timeout
                }
            }
        } else {
            # Standard: Alle Ports für eine IP durchgehen
            foreach ($TargetHost in $TargetHosts) {
                foreach ($Port in $PortList) {
                    Test-HostPortConnection -TargetHost $TargetHost -Port $Port -Ping:$Ping -Timeout $Timeout
                }
            }
        }

        $currentIteration++  # Zähler erhöhen
        # Warte für das angegebene Intervall, bevor die nächste Abfrage erfolgt
        Start-Sleep -Seconds $Interval
    }
}

function Test-HostPortConnection {
    param (
        [string]$TargetHost,
        [int]$Port,
        [switch]$Ping,
        [int]$Timeout
    )

    try {
        # DNS-Abfrage, um die IP-Adresse zu erhalten, falls es kein Subnet ist
        $ResolvedIPs = if ($TargetHost -match '\d{1,3}(\.\d{1,3}){3}') { 
            $TargetHost  # Falls es sich um eine IP handelt, verwende diese
        } else {
            [System.Net.Dns]::GetHostAddresses($TargetHost) | Select-Object -First 1
        }
    } catch {
        # Falls die DNS-Abfrage fehlschlägt
        Write-Host "Fehler bei der DNS-Auflösung für $TargetHost." -ForegroundColor Red
        return
    }

    if ($Ping) {
        # ICMP-Ping
        $pingResult = Test-Connection -ComputerName $TargetHost -Count 1 -ErrorAction SilentlyContinue
        if ($pingResult) {
            Write-Host "$TargetHost ($ResolvedIPs) | Status: Ping erfolgreich | Latenz: $($pingResult.ResponseTime) ms" -ForegroundColor Green
        } else {
            Write-Host "$TargetHost ($ResolvedIPs) | Status: Ping fehlgeschlagen"
        }
    } else {
        # TCP-Port-Test
        $TCPClient = [System.Net.Sockets.TcpClient]::new()

        # Starte die Zeitmessung für die Verbindung
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        # Versuche, eine Verbindung zu dem aktuellen Port herzustellen und warte auf das Ergebnis
        $Result = $TCPClient.ConnectAsync($ResolvedIPs, $Port).Wait($Timeout)

        # Stoppe die Zeitmessung
        $Stopwatch.Stop()
        $Latency = $Stopwatch.ElapsedMilliseconds  # Latenzzeit in Millisekunden

        # Schließe die Verbindung
        $TCPClient.Close()

        # Ausgabe der Verbindungsinformationen
        if ($Result) {
            Write-Host "$TargetHost ($ResolvedIPs) | Port: $Port | Status: True | Latenz: $Latency ms" -ForegroundColor Green
        } else {
            Write-Host "$TargetHost ($ResolvedIPs) | Port: $Port | Status: False"
        }

    }
                 
}

# Beispiel-Aufruf Single IP Single Port (like tnc)
Test-PortConnections -TargetHosts @("orf.at") -Ports @(80) -Count 1

# Beispiel-Aufruf der Funktion mit multi TargetHosts und multi Ports
Test-PortConnections -TargetHosts @("192.168.0.1","orf.at") -Ports @(80,443) -Count 1

# Beispiel-Aufruf der Funktion mit prioPort (ports)
Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Ports @(80,443) -prioPort -Count 1

# Beispiel-Aufruf der Funktion mit prioPort (ports) + PortRange
Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Ports @(80,443) -PortRangeStart 5000 -PortRangeEnd 5100 -prioPort -Count 1

# Beispiel-Aufruf der Funktion mit Ping IPRange
Test-PortConnections -Subnet "192.168.0" -StartRange 1 -EndRange 10 -Count 1 -Ping
function Send-WOL {
    param (
        [Parameter(Mandatory=$true)]
        [string]$MacAddress,
        [string]$BroadcastIP = "255.255.255.255",
        [int]$Port = 9
    )

    try {
        # MAC-Adresse formatieren und in Bytes umwandeln
        $cleanMac = $MacAddress -replace '[:\.-]', ''
        $macBytes = [byte[]]([regex]::Matches($cleanMac, '..') | ForEach-Object { [Convert]::ToByte($_.Value, 16) })

        # Magic Packet erstellen (6x 0xFF gefolgt von 16x der MAC-Adresse)
        $magicPacket = [byte[]](,0xFF * 6) + ($macBytes * 16)

        # UDP-Client initialisieren und Broadcast senden
        $udpClient = [System.Net.Sockets.UdpClient]::new()
        $udpClient.Connect([System.Net.IPAddress]::Parse($BroadcastIP), $Port)
        [void]$udpClient.Send($magicPacket, $magicPacket.Length)
        $udpClient.Close()

        Write-Host "Magic Packet erfolgreich an $MacAddress gesendet!" -ForegroundColor Green
    }
    catch {
        Write-Error "Fehler beim Senden des Magic Packets: $_"
    }
}

# Aufruf-Beispiel:
Send-WOL -MacAddress "00:11:32:bc:89:3f"
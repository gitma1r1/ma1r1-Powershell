#Azure-connect-Storage-Netzlaufwerk

$connectTestResult = Test-NetConnection -ComputerName csb100320023db9684c.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"csb100320023db9684c.file.core.windows.net`" /user:`"localhost\csb100320023db9684c`" /pass:`"kAZZUKPvGQhofNX56DDT8TzpD6gvNx/NYCmirLEtiuTfQENjkEn5+8aeYrHXqzaKMiHGgTac1Ti8+AStsahZOA==`""
    # Mount the drive
    New-PSDrive -Name Q -PSProvider FileSystem -Root "\\csb100320023db9684c.file.core.windows.net\cs-martin-mairinger-bmdtechnik-at-100320023db9684c" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}
##


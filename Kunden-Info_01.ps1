# Get the hostname
$hostname = $env:COMPUTERNAME
# Get hostname 2nd try
if ($hostname -eq $null){$hostname = hostname}

# Get the OS name and version
$os = Get-ComputerInfo -Property "OSName", "OSVersion"

# Get the IP address
$ipAddress = Get-NetIPAddress | Where-Object {$_.AddressFamily -eq "IPv4"} | Select-Object -First 1
# Get IP address 2nd try
if ($ipAddress -eq $null){ $ipAddress = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE).IPAddress[0]}  

# Get the antivirus product
$antivirusProduct = (Get-MpComputerStatus).AntivirusProduct
# Get antivirus product 2nd try
    if ($antivirusProduct -eq $null){$antivirusProduct = Get-MpComputerStatus}

# Check if SQL Server is installed
$sqlServerInstalled = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Microsoft SQL Server" -Name "ProductName" -ErrorAction SilentlyContinue
if ($sqlServerInstalled) {
    Write-Output "SQL Server is installed on this machine"
} else {
    Write-Output "SQL Server is not installed on this machine"
}

### Output
# Display the hostname, OS, IP address, and antivirus product
Write-Host "Hostname: $hostname" -ForegroundColor Yellow
Write-Host "OS: $($os.OSName) $($os.OSVersion)" -ForegroundColor Yellow
Write-Host "IP Address: $($ipAddress.IPAddress)" -ForegroundColor Yellow
Write-Host "Antivirus Product: $antivirusProduct" -ForegroundColor Yellow
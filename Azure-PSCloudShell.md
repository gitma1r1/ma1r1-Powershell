# Azure Cloud Powershell-Cheatsheet


> **MS quick start Azure Powershell Cloud: https://learn.microsoft.com/de-de/azure/cloud-shell/quickstart-powershell**


#### 01 - Azure Naming Convention

| First Header  | Second Header |
| ------------- | ------------- |
| Resource Group  | rg-​ |
| Virtual Network  | vnet- |
| Subnet | snet- |
| Network Security Group | nsg- |
| Public IP | pip- |	
| Virtual Machine | aspch- |
| VM Storage account | stvm |	
| NIC | _eth0 |
| Disk | _disk0 |
| Disk | _disk1 |

> **MS naming & tagging: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging**

> **Command-List MS Learn: https://learn.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest**

#### 02 - Skripts

##### Azure-Boot-Shutdown-VMs

```powershell

﻿#Credentials 
(get-credential).password|convertFrom-SecureString|set-content C:\Users\mai156\Desktop\cred-mai156-sp-aztechnik.txt $password = get-content C:\Users\mai156\Desktop\cred-mai156-sp-aztechnik.txt | convertto-securestring $User = "1b61339f4-e188-4d35f-a345d-4e4c92d048692d" $Credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $User, $password

# Sign in to your Azure subscription
Connect-AzAccount -Credential $Credential -ServicePrincipal -Tenant "9c8620b7-8359-456b-b0b4-c42a083a95f5" -Subscription "b57b2bbd-a86c-48e5-a1f7-9e9fe20d1e4f"
 #Disconnect-AzAccount

#Stop Stop-AzVM -ResourceGroupName "rg-loi357-prod" -Name "vm-loi357-prod" -Force

 #Start
Start-AzVM -ResourceGroupName "rg-loi357-prod" -Name "vm-mai156-prod"​



get-installedmodule -name az -allversions | Select-Object -Property Name, Version      #get Version of AZ module

connect-azaccount                                                                      #Login the Azure Account -> open Browser for Login

```

##### Azure-connect-Storage-Netzlaufwerk
   ```powershell

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

```


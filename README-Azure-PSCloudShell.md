# Azure Cloud Powershell


> **MS quick start:**
> - https://learn.microsoft.com/de-de/azure/cloud-shell/quickstart-powershell

## Azure Cloud Powershell-Cheatsheet

##### Azure Naming Convention

Resource Group	rg-​
Virtual Network	vnet-
Subnet	snet-
Network Security Group	nsg-
Public IP	pip-
Virtual Machine	aspch-
VM Storage account	stvm
NIC	_eth0
Disk	_disk0
	_disk1
	etc…

##### Install AZ Module for Powershell 7 (need first installed on Windows)
   ```powershell
Install-Module -Name AZ -AllowClobber -Force                                           #Install AZ Module (Powrshell 7)

get-installedmodule -name az -allversions | Select-Object -Property Name, Version      #get Version of AZ module

connect-azaccount                                                                      #Login the Azure Account -> open Browser for Login

```

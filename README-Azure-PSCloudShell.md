# Azure Cloud Powershell-Cheatsheet


> **MS quick start Azure Powershell Cloud: https://learn.microsoft.com/de-de/azure/cloud-shell/quickstart-powershell**


#### Azure Naming Convention

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

> **MS naming and tagging: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging**


##### Install AZ Module for Powershell 7 (need first installed on Windows)
   ```powershell
Install-Module -Name AZ -AllowClobber -Force                                           #Install AZ Module (Powrshell 7)

get-installedmodule -name az -allversions | Select-Object -Property Name, Version      #get Version of AZ module

connect-azaccount                                                                      #Login the Azure Account -> open Browser for Login

```

# Azure Cloud Powershell

## MS quick start

> **MS quick start:**
> - https://learn.microsoft.com/de-de/azure/cloud-shell/quickstart-powershell

## Azure Cloud Powershell-Cheatsheet


##### Get-Command & Get-Member
   ```powershell
   Get-Command                                          #like help in cmd 
   Get-Command | Sort-Object comand-type                #sorted output
   Get-Command -Module hyper-v | Out-GridView           #show all hyper-v cmdlets

   Get-ChildItem | Get-Member                           #Eigenschaften this gets you everything
   Get-ChildItem | Get-Member -MemberType Property      #Eigenschaften
```

##### get-help
   ```powershell
   get-help Get-Process -Examples                       #Hilfe von einem Befehl
   get-help Get-Process -Online                         #Hilfe online
   get-help *-item                                      #Hilfe über alle Befehle mit *-item
   update-help                                          #Hilfe aktuallisieren
```

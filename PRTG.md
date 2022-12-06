# PRTG

##### FSLogixFolderCheck

   ```powershell
$Folders = Get-ChildItem \\asp-upd-s-01\u$\UPD
$folder = $folders | where Name -Like "agg006*"
#$folder = $folders | where Name -Like "acc530*"
 
foreach ($Folder in $Folders) {
    
    if (Get-NTFSAccess -Path $Folder.Fullname | select Account | where Account -Like "S-*"){
        $Message += "$($Folder.Fullname) | "
        $Errorcounter ++
    }
}
```

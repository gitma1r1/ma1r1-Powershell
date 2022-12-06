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

##### Check Adobe Read installed on RDSH
   ```powershell
$ResultText = ""
 
$Programms = Get-WmiObject -Class Win32_Product | where Vendor -like "Adobe Systems Incorporated" | select Name | where Name -Like "Adobe*"
 
foreach($Programm in $Programms) {
    if ($Programm.name -eq "Adobe Acrobat Reader DC MUI"){$ResultText+= ""}
    if ($Programm.name -ne "Adobe Acrobat Reader DC MUI"){$ResultText+= "DC installiert - nicht ok"}
    return $ResultText
}
 
if ($ResultText -eq ""){
    $PRTGstring = "0:Alles OK"
}
else{
    $PRTGstring = "1:"+ $ResultText
}
 
write-host $PRTGstring!
```

##### Sfb2015share Check if File exist
   ```powershell
$Resulttext = ""
$Sensorstatus = 1
 
#Files einlesen
$Files = Get-ChildItem "\\bmd.com\dfs\sfb2015share\SamWin\ExportCSV\Mitarbeiter.xlsx" , "\\bmd.com\dfs\sfb2015share\SamWin\ExportCSV\Cloud_Kunden.xlsx" , "\\bmd.com\dfs\sfb2015share\SamWin\ExportCSV\Kunden-Lieferanten.csv"
 
foreach ($File in $Files){
    if ($File.LastWriteTime -le (Get-Date).AddDays(-2)){
        $Sensorstatus = 1
        $Resulttext += $File.Name +" Last Write Time "+ $File.LastWriteTime+" "
 
    }
    elseif ($File.LastWriteTime -ge (Get-Date).AddDays(-2)){
        $Sensorstatus = 0
        $Resulttext += $File.Name +" Last Write Time "+ $File.LastWriteTime+" " 
    }
 
}
    if ($Sensorstatus -eq 0){
        $PRTGstring ="0:"+$Resulttext
    }
    else{
    $PRTGstring ="1:"+$Resulttext
    }
 
#Ausgabe
write-host $PRTGstring
```

$log = "$home\Desktop\Log.txt" #Log Folder
$pathtomonitor = "D:\temp\test123" #Folder to monitor
$timeout = 1000 # wait between each while

try {
$FileSystemWatcher = New-Object System.IO.FileSystemWatcher $pathtomonitor
$FileSystemWatcher.IncludeSubdirectories = $true

Write-Host "Monitoring content of $PathToMonitor"
while ($true) {
  $change = $FileSystemWatcher.WaitForChanged('All', $timeout)
  if ($change.TimedOut -eq $false)
  {
      # get information about the changes detected
      Write-Host "Change detected:"
      # invoke some actions here when change detected
      if (!($change.ChangeType -eq 'Deleted')){
          #Start-Process $change.name -WorkingDirectory $pathtomonitor -verb PrintTo '\\printerserver\printer1' -PassThru | %{ sleep 10;$_ } | kill
      }
      $change | Out-Default
      (Get-Date).ToString() + ", " + $change.ChangeType.ToString() + ", " + $change.Name | Out-File $log -Append
   }
  else
  {
      Write-Host "." -NoNewline
  }
 }
}
finally{
  $FileSystemWatcher.Dispose()
  Write-Host "My Watcher is done."
}

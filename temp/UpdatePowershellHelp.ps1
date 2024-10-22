#requires -module ScheduledTasks

#update PowerShell help via a Scheduled Task
$cred = Get-Credential "nb-mai156-neu\admin"

# for Windows PowerShell
# $action = New-ScheduledTaskAction -execute  powershell.exe -argument '-noprofile -command "&{Update-Help -force}"'
$actionparams = @{
    execute  = 'pwsh.exe'
    argument = '-nologo -noprofile -noninteractive -command "&{Update-Help -force}"'
}
$action = New-ScheduledTaskAction @actionparams

$params = @{
    TaskName = "Monthly PowerShell Core Help Update"
    TaskPath = "\Microsoft\Windows\PowerShell"
    Trigger  = New-ScheduledTaskTrigger -At 8:00AM -Weekly -WeeksInterval 4 -DaysOfWeek Monday
    Action   = $action
    User     = $cred.UserName
    Password = $cred.GetNetworkCredential().Password
    Runlevel = "Highest"
}

Register-ScheduledTask @params
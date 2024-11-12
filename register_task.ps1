$action = New-ScheduledTaskAction -WorkingDirectory "c:\windows\system32" -Execute "Robocopy.exe" -Argument "C:\WEBSITE C:\INETPUB\\WWWROOT /S /XF .DS_Store /XD .git"
$trigger = New-ScheduledTaskTrigger -At (Get-Date) -Once -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-TimeSpan -Days 1) 
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger 
Register-ScheduledTask -TaskName "Sync Website Files" -InputObject $task -Force
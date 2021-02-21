
## --Parameters-and-Variables---
param ([switch] $cool=$true, $fs=$true)
$sleeptime = 120



## --Functions---

function fGetTimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function fExitNsfm {
    Get-Process nsfminer -ErrorAction SilentlyContinue | Stop-Process
    Sleep 5
    if(!$(Get-Process nsfminer -ErrorAction SilentlyContinue)) { Stop-Process nsfminer -Force }
}

function fFS { 
 if ($(Get-Process FlightSimulator -ErrorAction SilentlyContinue)) {
  Write-Output " LOG:  FlightSimulator is opened, do not start."
  if ($(Get-Process nsfminer -ErrorAction SilentlyContinue)) {
      Write-Output " LOG:   Mining soft is opened, exiting..."
      fExitNsfm
   }
 } elseif ($(Get-Process nsfminer -ErrorAction SilentlyContinue)) {
  Write-Output " LOG:  Mining soft is opened, sleeping."
 } else {
  Write-Output " Starting the mining at $(fGetTimeStamp). "
  cmd /c "start C:\install\nsfminer.exe -P stratum1+ssl://0x5d6122C69F627f3a6eF4C9C697bE538A065987f4.$(hostname)@us1.ethermine.org:5555 -U"
  if (!$(Test-Path C:\install\nsfm.lock)) { echo $null >> C:\install\nsfm.lock }
 }
}

function fCooling {
    if ($(Test-Path C:\install\nsfm.lock)) {
        if (($(Get-Date) - $((Get-Item C:\install\nsfm.lock).LastWriteTime)).totalhours -gt 4) { 
            #if (($(Get-Date) - $((Get-Item C:\install\nsfm.lock).LastWriteTime)).totalhours -lt 12) {
               Write-Output " Mining has been running for 4+ hours. "
               fExitNsfm
               rm C:\install\nsfm.lock
               Write-Output " Cooling off for 20min now. "
               Start-Sleep -Seconds 1200
            #}
        }
    }
}

function fscktask {
    if (!$(Get-ScheduledTask fsmine -ErrorAction SilentlyContinue)) {
        $taskAction = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-ExecutionPolicy Bypass -File C:\install\fsmine_main.ps1'
        $taskTrigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -minutes 1)
        $taskSettings = New-ScheduledTaskSettingsSet -DisallowHardTerminate -DontStopOnIdleEnd
            $taskSettings.ExecutionTimeLimit = 'PT0S'
        Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName "fsmine" -Settings $taskSettings -User "System"
    }
}



## --Main-program---

Write-Output `n
Write-Output " Script started at $(fGetTimeStamp)."

fscktask
rm C:\install\nsfm.lock -ErrorAction SilentlyContinue

while ($cool -or $fs) {
 
 if ($cool) { fCooling }
 if ($fs) { fFS }
  
 Start-Sleep -Seconds $sleeptime
 
}



## --Sources---
 #  https://stackoverflow.com/questions/28481811/how-to-correctly-check-if-a-process-is-running-and-stop-it#28482050
 #  https://dmitrysotnikov.wordpress.com/2009/06/29/prevent-desktop-lock-or-screensaver-with-powershell/
 #  https://stackoverflow.com/questions/22364947/run-powershell-if-statement-between-business-hours
 #  https://geekeefy.wordpress.com/2015/06/11/powershell-infinite-loops-for-testing-purpose/
 #  https://www.gngrninja.com/script-ninja/2016/2/12/powershell-quick-tip-simple-logging-with-timestamps
 #  https://docs.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-7.1
 #  https://www.red-gate.com/simple-talk/sysadmin/powershell/how-to-use-parameters-in-powershell/
 #  https://stackoverflow.com/questions/14405587/powershell-mandatory-bool-always-true
 #  https://social.technet.microsoft.com/wiki/contents/articles/23826.powershell-how-to-use-switch-parameter.aspx
 #  https://superuser.com/questions/502374/equivalent-of-linux-touch-to-create-an-empty-file-with-powershell
 #  https://www.shellhacks.com/windows-touch-command-equivalent/
 #  https://www.spguides.com/powershell-find-files-modified-in-last-24-hours-and-powershell-get-last-modified-time-of-files-in-folder/
 #  https://www.powershelladmin.com/wiki/Use_test-path_with_powershell_to_check_if_a_file_exists
 #  https://adamtheautomator.com/how-to-get-a-computer-name-with-powershell/
 #  https://adamtheautomator.com/powershell-scheduled-task/
 #  https://stackoverflow.com/questions/2000674/powershell-create-scheduled-task-to-run-as-local-system-service
 #  https://dscottraynsford.wordpress.com/2017/12/17/create-a-scheduled-task-with-unlimited-execution-time-limit-in-powershell/
 

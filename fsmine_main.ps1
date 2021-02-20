
## --Parameters-and-Variables---
param ([switch] $cool=$true, $fs=$true)
$sleeptime = 120



## --Functions---

function fGetTimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function fExitNsfm {
    Get-Process nsfminer | Stop-Process
    Sleep 5
    Get-Process nsfminer -ErrorAction SilentlyContinue | Stop-Process -Force
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
  cmd /c 'start C:\install\nsfminer.exe -P stratum1+ssl://0x5d6122C69F627f3a6eF4C9C697bE538A065987f4.Slsh@us1.ethermine.org:5555 -U'
  if (!$(Test-Path C:\install\nsfm.lock)) { echo $null >> C:\install\nsfm.lock }
 }
}

function fCooling {
    if (($(fGetTimeStamp) - $((Get-Item C:\install\nsfm.lock -ErrorAction SilentlyContinue).LastWriteTime)).totalhours -gt 6) { 
        if (($(fGetTimeStamp) - $((Get-Item C:\install\nsfm.lock -ErrorAction SilentlyContinue).LastWriteTime)).totalhours -lt 12) {
           Write-Output " Mining has been running for 6+ hours. Cooling off now. "
           fExitNsfm
           rm C:\install\nsfm.lock
        }
    }
}



## --Main-program---

Write-Output `n
Write-Output " Script started at $(fGetTimeStamp)."

while ($cool -or $fs) {
 
 if ($fs) { fFS }
 if ($cool) { fCooling }
  
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
 

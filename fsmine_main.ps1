
## --Parameters-and-Variables---
param ([switch] $cool=$true, $fs=$false)



## --Functions---

function GetTimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function fCooling {
    #bkebke
}

function Looping {
 Write-Output `n
 Write-Output " LOG:  started looping at $(GetTimeStamp)."
 Clear-Variable -Name ("flightsim", "nsfm", "sleeptime") -ErrorAction SilentlyContinue
 
 $sleeptime = 120
 $flightsim = Get-Process FlightSimulator -ErrorAction SilentlyContinue
 $nsfm = Get-Process nsfminer -ErrorAction SilentlyContinue
 
 if ($flightsim) {
  Write-Output " LOG:  FlightSimulator is opened, do not start."
  if ($nsfm) {
      # try gracefully first
      $nsfm | Stop-Process
      # kill after five seconds
      Sleep 5
      if (!$nsfm.HasExited) {
        $nsfm | Stop-Process -Force
       }
   }
  Start-Sleep -Seconds $sleeptime
 } elseif ($nsfm) {
  Write-Output " LOG:  Mining soft is opened, sleeping."
  Start-Sleep -Seconds $sleeptime
 } else {
  Write-Output " `n starting the mining at $(GetTimeStamp). `n "
  cmd /c 'start C:\install\nsfminer.exe -P stratum1+ssl://0x5d6122C69F627f3a6eF4C9C697bE538A065987f4.Slsh@us1.ethermine.org:5555 -U'
  Start-Sleep -Seconds $sleeptime
 }
}



## --Main-program---

while ($true) {
 Looping
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
 

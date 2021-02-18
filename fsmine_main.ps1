
while ($true) {

 Clear-Variable -Name ("flightsim", "var2")
 
 $sleeptime = 120
 $flightsim = Get-Process FlightSimulator -ErrorAction SilentlyContinue
 $nsfm = Get-Process nsfminer -ErrorAction SilentlyContinue
 
 if ($flightsim) {
   # FlightSimulator is opened, do not start
  Start-Sleep -Seconds $sleeptime
 } elseif ($nsfm) {
   # Mining soft is opened, sleeping
  Start-Sleep -Seconds $sleeptime
 } else {
   # starting the mining
  cmd /c 'start C:\install\nsfminer.exe -P stratum1+ssl://0x5d6122C69F627f3a6eF4C9C697bE538A065987f4.Slsh@us1.ethermine.org:5555 -U'
  Start-Sleep -Seconds $sleeptime
 }
}



## --Sources---
 #  https://stackoverflow.com/questions/28481811/how-to-correctly-check-if-a-process-is-running-and-stop-it#28482050
 #  https://dmitrysotnikov.wordpress.com/2009/06/29/prevent-desktop-lock-or-screensaver-with-powershell/
 #  https://stackoverflow.com/questions/22364947/run-powershell-if-statement-between-business-hours
 #  https://geekeefy.wordpress.com/2015/06/11/powershell-infinite-loops-for-testing-purpose/


while ($true) {
 $flightsim = Get-Process FlightSimulator -ErrorAction SilentlyContinue
 if ($flightsim) {
  # FlightSimulator is opened, do not start
  Start-Sleep -Seconds 60
 } else {
  # starting the mining
  cmd /c 'start C:\install\nsfminer.exe -P stratum1+ssl://0x5d6122C69F627f3a6eF4C9C697bE538A065987f4.Slsh@us1.ethermine.org:5555 -U'
  Start-Sleep -Seconds 60
 }
}

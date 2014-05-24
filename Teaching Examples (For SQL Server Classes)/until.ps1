$sec = 0
do { Write-Host "Checking second "$sec.ToString(); Sleep -Seconds 1; $sec++ }
until ( $x -eq 60 )

Write-Host "Complete."

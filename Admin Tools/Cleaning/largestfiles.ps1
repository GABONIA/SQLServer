## Returns 25 largest files
Get-ChildItem . -Recurse | sort Length -desc | Select FullName -First 25

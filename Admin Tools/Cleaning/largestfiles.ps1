## Returns 25 largest files
Get-ChildItem . -r | sort Length -desc | Select FullName -f 25

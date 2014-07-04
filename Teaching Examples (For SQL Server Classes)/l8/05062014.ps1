$f = Get-Content "C:\files\inflationdata.csv"
$l = $f.Length

if ($l -gt 120000)
{
 ## Import function
}



$x = Get-ChildItem "C:\files\inflationdata.csv" | Measure-Object -Sum length
## Measures MB
if (($x.Sum / 1MB) -gt 3)
## Measures GIG
##if (($x.Sum / 1GB) -gt 3)
{
    ## Import function
}

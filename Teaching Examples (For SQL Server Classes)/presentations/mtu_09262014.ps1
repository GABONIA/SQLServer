##  Window 1
$string = "This is a simple string object"

$string.Length
$string.Contains("simple")



##  Window 2
$newobject = ""
 
$othernewobject = $newobject.Substring(0,10)
$anothernewobject = $othernewobject.Substring(0,7)
$anothernewobject.Substring(0,2)

$newobject = ""
 
$othernewobject = $newobject.Substring(0,10)
$anothernewobject = $othernewobject.Substring(0,7)
$anothernewobject.Substring(0,2)
 
$object = 2
Write-Host ($object/0).ToString()



Window 3
$smo = "C:\Program Files\Microsoft SQL Server\110\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
Add-Type -Path $smo


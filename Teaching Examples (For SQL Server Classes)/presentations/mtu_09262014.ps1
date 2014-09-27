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



## Window 3
$smo = "C:\Program Files\Microsoft SQL Server\110\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
Add-Type -Path $smo



## Window 4
$server = "SERVER\INSTANCE"
Add-Type -Path "C:\Program Files\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
$srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

foreach ($d in $srv.Databases | Where-Object {$_.IsSystemObject -eq $false})
{
    $d.Name
}



## Window 5
Function Get-DBModel ($server)
{
    Add-Type -Path "C:\Program Files\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    foreach ($d in $srv.Databases | Where-Object {$_.IsSystemObject -eq $false})
    {
        $d.RecoveryModel
    }
}

Get-DBModel -server "SERVER\INSTANCE"


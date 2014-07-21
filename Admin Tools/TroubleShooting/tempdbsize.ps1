Function SizingTempDB ($location, $sizeGB)
{
    $files = Get-ChildItem $location -Include @("*.mdf", "*.ldf") -Recurse
    foreach ($file in $files)
    {
        $x = Get-ChildItem $file.FullName | Measure-Object -Sum Length
        $x = ($x.Sum/1GB)
        $total += $x
    }

    if ($total -gt $size)
    {
        Write-Host $total
    }
}

SizingTempDB -location "" -sizeGB 

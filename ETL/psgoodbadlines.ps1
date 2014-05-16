## See: https://github.com/tmmtsmith/SQLServer/blob/master/ETL/CSharpWriteBadAndGoodLinesByDelimiter.cs

Function GetLastLineNumber ($file)
{
    $readfile = New-Object System.IO.StreamReader($file)
    $cnt = 0
    while ($line = $readfile.ReadLine())
    {
        $cnt++
    }
    $readfile.Close()
    $readfile.Dispose()
    return $cnt
}

GetLastLineNumber -file "C:\files\OurBigFile.txt"

<#

$x = Get-Content "C:\files\OurBigFile.txt" | Measure-Object -Line | Select-Object -Property Lines
$x.Lines

#>

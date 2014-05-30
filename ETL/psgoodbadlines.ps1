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


Function GetLineByNumber ($file, $lineno)
{
    $readfile = New-Object System.IO.StreamReader($file)
    $line = ""
    for ($i = 1; $i -lt ($lineno + 1); $i++)
    {
        $line = $readfile.ReadLine()
    }
    $readfile.Close()
    $readfile.Dispose()
    return $line
}

GetLineByNumber -file "C:\files\new.txt" -lineno 2

<#

$x = Get-Content "C:\files\OurBigFile.txt" | Measure-Object -Line | Select-Object -Property Lines
$x.Lines

$file = "C:\files\files\files\file.txt"
$buildofffile = $file.Substring(0, $file.LastIndexOf(".")) + "middle" + $file.Substring($file.LastIndexOf("."),($file.Length - $file.LastIndexOf(".")))
$other = Get-ChildItem $file | Select-Object -Property Name

#>

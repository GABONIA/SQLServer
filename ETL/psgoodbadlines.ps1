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

Function SeparateGoodBadLines ($file, $ch, $validCount)
{
    $ext = $file.Substring($file.LastIndexOf("."))
    $loc = $file.Substring(0,($file.LastIndexOf("\")+1))
    $name = $file.Substring($file.LastIndexOf("\")+1).Replace($ext,"")

    $valid = $loc + $name + "_valid" + $ext
    $invalid = $loc + $name + "_invalid" + $ext

    New-Item $valid -ItemType file
    New-Item $invalid -ItemType file

    $read = New-Object System.IO.StreamReader($file)
    $wValid = New-Object System.IO.StreamWriter($valid)
    $wInvalid = New-Object System.IO.StreamWriter($invalid)

    while (($line = $read.ReadLine()) -ne $null)
    {
        $total = $line.Split($ch).Length - 1;
        if ($total -eq $validCount)
        {
            $wValid.WriteLine($line)
            $wValid.Flush()
        }
        else
        {
            $wInvalid.WriteLine($line)
            $wInvalid.Flush()
        }
    }

    $read.Close()
    $read.Dispose()
    $wValid.Close()
    $wValid.Dispose()
    $wInvalid.Close()
    $wInvalid.Dispose()
}

<#

$x = Get-Content "C:\files\OurBigFile.txt" | Measure-Object -Line | Select-Object -Property Lines
$x.Lines

$file = "C:\files\files\files\file.txt"
$buildofffile = $file.Substring(0, $file.LastIndexOf(".")) + "middle" + $file.Substring($file.LastIndexOf("."),($file.Length - $file.LastIndexOf(".")))
# Other:
$name = Get-ChildItem $file | Select-Object -Property Name
$basename = Get-ChildItem $file | Select-Object -Property BaseName
$fullname = Get-ChildItem $file | Select-Object -Property FullName # redundant
#>

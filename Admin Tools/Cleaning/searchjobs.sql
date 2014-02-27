/*

$sv = ""
$s = New-Object "Microsoft.SqlServer.Management.Smo.Server" $sv

foreach ($j in $s.JobServer.Jobs)
{
    [string]$x = $j.Name
    
    if (($j.Name -like "*something*") -and ($j.Name -notlike "*something*"))
    {
        $file = "C:\Files\" + $x + ".sql"
        $y = $j.Script()
        $y = "USE msdb  GO  " + $y
        ##$y = $y.Replace("textone","texttwo")
        if ($y -like "*something*")
        {
            ## Step further
            $y | Out-File $file
        }
    }
}

*/

SELECT *
FROM msdb.dbo.sysjobs

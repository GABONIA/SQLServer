Function FindUnusedJobs ($server)
{
    $s = New-Object "Microsoft.SqlServer.Management.Smo.Server" $server

    foreach ($j in $s.JobServer.Jobs)
    {
        $y = $j.LastRunDate.Year.ToString()
        if ($y.Length -lt 4)
        {
            Write-Host $j.Name
        }
    }
}

FindOldOrUnusedJobs -server "SERVER\INSTANCE"

<#
## Loop through multiple servers approach:

$ss = "SERVER\INSTANCE","SERVER2\INSTANCE2"

foreach ($s in $ss)
{
    $srv = New-Object "Microsoft.SqlServer.Management.Smo.Server" $s
    foreach ($j in $srv.JobServer.Jobs)
    {
        $y = $j.LastRunDate.Year.ToString()
        if ($y.Length -lt 4)
        {
            Write-Host Server $s Job $j.Name
        }
    }
    $srv = ""
}

#>

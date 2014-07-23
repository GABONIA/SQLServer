## Cube Heartbeat

Function AnalysisServer_Heartbeat ($server, $database, $filepath, $emailto, $smtpserver)
{
    $files = Get-ChildItem $filepath
    $nl = [Environment]::NewLine
    
    foreach ($file in $files | Where-Object { $_.Name -like "*.mdx*" })
    {
        $mdx = Get-Content $file.FullName
        $heartbeat = Invoke-ASCmd -Server $server -Database $database -Query $mdx
        $error = "Either connection to $server failed, or the below query failed." + $nl + $nl + $mdx

        if ((!$heartbeat) -or ($heartbeat -like "*not been processed*"))
        {
            $error
            Send-MailMessage -To $emailto -From "Cube Alerts <cubealerts@ssas.com>" -Subject "Cube Heartbeat Failure" -Body $msg -SmtpServer $smtpserver    
        }
        else
        {
            Write-Host "Heartbeat(s) successfully ran."
        }
    }
}

AnalysisServer_Heartbeat -server "" -database "" -filepath "" -emailto "" -smtpserver ""

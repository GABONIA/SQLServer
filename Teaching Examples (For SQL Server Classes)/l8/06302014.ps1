Function FindUnusedStoredProcedures ($server, $githubfolder, $smolibrary)
{
    Add-Type -Path $smolibrary
    $serv = New-Object Microsoft.SqlServer.Management.Smo.Server($server)

    foreach ($d in $serv.Databases | Where-Object {$_.IsSystemObject -eq $false})
    {
        foreach ($proc in $d.StoredProcedures | Where-Object {$_.IsSystemObject -eq $false})
        {
            $p = $proc.Name
            $cnt = Get-ChildItem $githubfolder -Include @("*.sql", "*.cs", "*.xml", "*.ps1") -Recurse | Select-String -pattern $p
            if ($cnt.Count -lt 2)
            {
                $scon = New-Object System.Data.SqlClient.SqlConnection
                $scon.ConnectionString = "SERVER=$server;DATABASE=Logging;Integrated Security=true"
                $record = New-Object System.Data.SqlClient.SqlCommand
                $record.Connection = $scon
                $record.CommandText = "INSERT INTO UnusedStoredProcedures (DatabaseName,ProcedureName) SELECT '$d', '$p'"

                $scon.Open()
                $record.ExecuteNonQuery()
                $scon.Close()
                $scon.Dispose()
            }
        }
    }
}

FindUnusedStoredProcedures -server "" -githubfolder "" -smolibrary ""

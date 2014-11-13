Function Size-DBs ($server, $db, $smo, $ep = $null)
{
    $nl = [Environment]::NewLine
    Add-Type -Path $smo
    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)
    $dse_arr = @()
 
    foreach ($d in $srv.Databases | Where-Object {($_.IsSystemObject -eq $false)})
    {   
        $d_ID = $d.ID

        ## Handling the log
        $l = 0
        foreach ($lg in $d.LogFiles)
        {
            $l += $lg.Size/1024
        }
        $d_US = (($d.Size - ($d.SpaceAvailable/1024)) - $l)
        
        if ($ep -ne $null)
        {
            $d_EX = (($d.Size - ($d.SpaceAvailable/1024))*$ep)
            $dse_arr += $nl + "INSERT INTO Logging_Sizes (DatabaseID, DatabaseSize, ExpectedGrowth) VALUES (" + $d_ID + "," + $d_US + ", " + $d_EX + ")"
        }
        else
        {
            $dse_arr += $nl + "INSERT INTO Logging_Sizes (DatabaseID, DatabaseSize) VALUES (" + $d_ID + "," + $d_US + ")"
        }
    }

    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER="+ $server +";DATABASE=" + $db + ";Integrated Security=true"
    $ld = New-Object System.Data.SqlClient.SqlCommand
    $ld.CommandText = $dse_arr
    $ld.Connection = $scon
 
    $scon.Open()
    $ld.ExecuteNonQuery()
    $scon.Close()
    $scon.Dispose()
}
 
Size-DBs -server "OURSERVER\OURINSTANCE" -db "Logging" -smo "C:\Program Files\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll" -ep 1.05

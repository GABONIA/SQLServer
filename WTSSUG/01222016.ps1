
Function Quick-TableCount {
    Param(
        [ValidateLength(4,30)][string]$cnt_srv
        , [ValidateLength(4,30)][string]$cnt_db
        , [ValidateLength(1,50)][string]$cnt_tab
    )
    Process
    {
        $nl = [Environment]::NewLine
        $smo = "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
        Add-Type -Path $smo

        $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($cnt_srv)

        [int]$reptab_rwcnt = $srv.Databases["$cnt_db"].Tables["$cnt_tab"].RowCount
        
        if ($reptab_rwcnt -ne $null)
        {
            return $reptab_rwcnt
        }
    }
}

Quick-TableCount -cnt_srv "" -cnt_db "" -cnt_tab ""




Function Execute-Sql {
    Param(
        [ValidateLength(3,45)][string]$server
        , [ValidateLength(10,4000)][string]$command
    )
    Process
    {
        $scon = New-Object System.Data.SqlClient.SqlConnection
        $scon.ConnectionString = "Data Source=$server;Initial Catalog=master;Integrated Security=true;Connection Timeout=5;"
        
        $cmd = New-Object System.Data.SqlClient.SqlCommand
        $cmd.Connection = $scon
        $cmd.CommandTimeout = 5
        $cmd.CommandText = $command

        try
        {
            $scon.Open()
            $cmd.ExecuteNonQuery() | Out-Null
        }
        catch [Exception]
        {
            Write-Warning "Execute-Sql ($server)"
            Write-Warning $_.Exception.Message
            Write-Warning $command
        }
        finally
        {
            $scon.Dispose()
            $cmd.Dispose()
        }
    }
}




Function Heartbeat-Server {
    Param(
        [ValidateLength(3,45)][string]$hbserver
        , [ValidateLength(3,45)][string]$hbdatabase
        , [ValidateLength(10,4000)][string]$hbcommand
        , [ValidateLength(1,40)][string]$hbcolumn
    )
    Process
    {
        $scon = New-Object System.Data.SqlClient.SqlConnection
        $scon.ConnectionString = "Data Source=$hbserver;Initial Catalog=$hbdatabase;Integrated Security=true;Connection Timeout=5;"

        $cmd = New-Object System.Data.SqlClient.SqlCommand
        $cmd.Connection = $scon
        $cmd.CommandText = $hbcommand
        $cmd.CommandTimeout = 5
        
        try
        {
            $scon.Open()
            $sqlread = $cmd.ExecuteReader()
    
            while ($sqlread.Read())
            {
                $outputcolumn = $sqlread["$hbcolumn"]
                Write-Host $outputcolumn
            }
        }
        catch [Exception]
        {
            Write-Warning "Heartbeat-Server"
            Write-Warning $_.Exception.Message
        }
        finally
        {
            $cmd.Dispose()
            $scon.Dispose()
        }
    }
}

Heartbeat-Server -hbserver "" -hbdatabase "" -hbcommand "" -hbcolumn ""

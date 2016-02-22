
Function Check-ServerListOnline {
    Param(
        [ValidateLength(4,100)][string]$server
		, [ValidateLength(4,50)][string]$dbaserver
    )
    Process
    {
        $scon = New-Object System.Data.SqlClient.SqlConnection
        $scon.ConnectionString = "Data Source=$server;Initial Catalog=master;Integrated Security=true"
        
	    $cmd = New-Object System.Data.SqlClient.SqlCommand
        $cmd.Connection = $scon
        $cmd.CommandText = "SELECT NEWID()"
        $cmd.CommandTimeout = 20
        
		try 
        {
            $scon.Open()
            $sqlread = $cmd.ExecuteReader()

            while ($sqlread.Read())
            {
                $returnvalue = $sqlread.GetValue($value)
                Write-Host $returnvalue

                $active = "
                UPDATE DBA.dbo.tb_ServerList
                SET Active = 1
                WHERE InstanceName = '$server'
                "

                Execute-Sql -server $dbaserver -command $active
            }
        }
        catch [Exception]
        {
            $script_update = "
            UPDATE DBA.dbo.tb_ServerList
            SET Active = 0
            WHERE InstanceName = '$server'
            "
            
            Write-Warning "$server not accessible. Setting to inactive."
            Execute-Sql -server $dbaserver -command $script_update
        }
        finally
        {
            $scon.Dispose()
            $cmd.Dispose()
        }
    }
}



Function Read-ServerList {
    Param(
        [ValidateLength(4,100)][string]$server
    )
    Process
    {
        $scon = New-Object System.Data.SqlClient.SqlConnection
        $scon.ConnectionString = "Data Source=$server;Initial Catalog=DBA;Integrated Security=true;"
        
        $cmd = New-Object System.Data.SqlClient.SqlCommand
        $cmd.Connection = $scon
        $cmd.CommandText = "SELECT InstanceName FROM DBA.dbo.tb_ServerList"
        $cmd.CommandTimeout = 0
        
        try
        {
            $scon.Open()
            $readlist = $cmd.ExecuteReader()
    
            while ($readlist.Read())
            {
                [string]$run_server = $readlist["InstanceName"]
                Check-ServerOnline -server $run_server -dbaserver $server
            }
        }
        catch [Exception]
        {
            Write-Warning "Read-ServerList"
            Write-Warning $_.Exception.Message
        }
        finally
        {
            $cmd.Dispose()
            $scon.Dispose()
        }
    }
}


Read-ServerList

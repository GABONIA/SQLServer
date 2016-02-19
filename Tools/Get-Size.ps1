<#

CREATE TABLE DBA.dbo.tb_DatabaseSizes(
	ServerName VARCHAR(150),
	DatabaseName VARCHAR(250),
	SizeInGB DECIMAL(23,11),
	SizeDate DATETIME
)

#>



Function Get-Size {
    Param(
        [ValidateLength(30,500)][string]$smolibrary
        , [ValidateLength(4,150)][string]$server
    )
    Process
    {
        $nl = [Environment]::NewLine
        Add-Type -Path $smolibrary

        $sqlsrv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

        foreach ($db in $sqlsrv.Databases | Where-Object {$_.id -gt 4})
        {
            $dbname = $db.Name
            $size = ($db.Size/1024)

            $add_size ="INSERT INTO DBA.dbo.tb_DatabaseSizes VALUES ('$server','$dbname',$size,GETDATE())"
            #Write-Host $add_size
            Execute-Sql -server "P-DBAU1-V" -command $add_size
        }
    }
}



Function Read-ServerList {
    Param(
        [ValidateLength(30,500)][string]$smolibrary
        , [ValidateLength(4,150)][string]$server
    )
    Process
    {
        $scon = New-Object System.Data.SqlClient.SqlConnection
        $scon.ConnectionString = "Data Source=$server;Initial Catalog=master;Integrated Security=true;"
        
        $cmd = New-Object System.Data.SqlClient.SqlCommand
        $cmd.Connection = $scon
        $cmd.CommandText = "SELECT InstanceName FROM DBA.dbo.tb_ServerList"
        $cmd.CommandTimeout = 0

        [string]$fullerrorlist = ""
        
        try
        {
            $scon.Open()
            $readlist = $cmd.ExecuteReader()
    
            while ($readlist.Read())
            {
                [string]$run_server = $readlist["InstanceName"]
                try
                {
                    Get-Size -smolibrary $smo -server $run_server
                }
                catch [Exception]
                {
                    Write-Warning "Inside Reader Catch (Read-ServerList)"
                    Write-Warning $_.Exception.Message
                }
            }
        }
        catch
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


$smo = "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"

Read-ServerList -server "" -smolibrary $smo

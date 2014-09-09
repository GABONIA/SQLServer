Function CheckObjectValidity ($server, $smolibrary)
{
    Add-Type -Path $smolibrary
    $serv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)
    foreach ($db in $serv.Databases | Where-Object {$_.IsSystemObject -eq $false})
    {
        $d = $db.Name
        ## We can test other objects as well, see Microsoft's documentation on sys.sp_refreshsqlmodule
        ## ie:
        ##foreach ($view in $db.Views) | Where-Object {$_.IsSystemObject -eq $false})
        ##foreach ($udf in $db.UserDefinedFunction) | Where-Object {$_.IsSystemObject -eq $false})
        foreach ($proc in $db.StoredProcedures | Where-Object {$_.IsSystemObject -eq $false})
        {
            $o = $proc.Name
   ## Gets the schema for the procedure
            $sc = $proc.Schema
 
            $scon = New-Object System.Data.SqlClient.SqlConnection
            $scon.ConnectionString = "SERVER=" + $server + ";DATABASE=" + $d + ";Integrated Security=true"
            $trycmd = New-Object System.Data.SqlClient.SqlCommand
            $catchcmd = New-Object System.Data.SqlClient.SqlCommand
   ## We refresh the object with the schema.table
            $trycmd.CommandText = "EXECUTE sys.sp_refreshsqlmodule '$sc.$o'"
            $trycmd.Connection = $scon
            $catchcmd.CommandText = "INSERT INTO Logging.dbo.ObjectValidityTable (DatabaseName,ObjectName) VALUES ('$d','$o')"
            $catchcmd.Connection = $scon
 
            try
            {
                $scon.Open()
                $trycmd.ExecuteNonQuery()
            }
            catch
            {
                $catchcmd.ExecuteNonQuery()
            }
            finally
            {
                $scon.Close()
                $scon.Dispose()
            }
        }
    }
}

## Only enter the server and file locatin of the SMO library
CheckObjectValidity -server "" -smolibrary ""

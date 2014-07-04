Function AutoImportCommaFlatFiles($location, $file, $extension, $server, $database)
{
    $full = $location + $file + $extension
    $all = Get-Content $full
    $columns = $all[0]
    $columns = $columns.Replace(" ","")
    $columns = $columns.Replace(",","] VARCHAR(100), [")
    $table = "CREATE TABLE " + $file + "([" + $columns + "] VARCHAR(100))"
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $buildTable = New-Object System.Data.SqlClient.SqlCommand
    $insertData = New-Object System.Data.SqlClient.SqlCommand
    $connection.ConnectionString = "Data Source=" + $server + ";Database=" + $database + ";integrated security=true"
    $buildTable.CommandText = $table
    $buildTable.Connection = $connection
    ## Added to function
    $x = 0
    $insertData.CommandText = "EXECUTE stp_CommaBulkInsert @1,@2"
    $insertData.Parameters.Add("@1", $full)
    $insertData.Parameters.Add("@2", $file)
    $insertData.Connection = $connection
    $connection.Open()
    $buildTable.ExecuteNonQuery()
    $connection.Close()
    ## Added to function
    $x = 1
    if ($x = 1)
    {
        $connection.Open()
        $insertData.ExecuteNonQuery()
        $connection.Close()
    }
}
AutoImportCommaFlatFiles -location "" -file "" -extension "" -server "" -database ""

<#

CREATE PROCEDURE stp_CommaBulkInsert
@file NVARCHAR(250), @table NVARCHAR(250)
AS
BEGIN
  DECLARE @f NVARCHAR(250), @t NVARCHAR(250), @s NVARCHAR(MAX)
  SET @f = @file
  SET @t = @table
  
  SET @s = N'BULK INSERT ' + @t + '
  FROM ''' + @f + '''
  WITH (
   FIELDTERMINATOR = '',''
   ,ROWTERMINATOR = ''0x0a''
   ,FIRSTROW=2
  )'
  
  EXEC sp_executesql @s
END

#>

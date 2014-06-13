## Other del, add

Function CountData ($file, $ch, $server, $db)
{
    $ext = $file.Substring($file.LastIndexOf("."))
    $name = $file.Substring($file.LastIndexOf("\")+1).Replace($ext,"")
 
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=$server;DATABASE=$db;Integrated Security=true"
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $scon
 
    $lineno = 0
 
    $read = New-Object System.IO.StreamReader($file)
 
    while (($line = $read.ReadLine()) -ne $null)
    {
        $lineno++
        $total = $line.Split($ch).Length - 1;
        $cmd.CommandText = "IF OBJECT_ID('$name') IS NULL BEGIN CREATE TABLE $name ([LineNumber] BIGINT, [CharCount] BIGINT) END  INSERT INTO $name VALUES ($lineno,$total)"
        $scon.Open()
        $cmd.ExecuteNonQuery()
        $scon.Close()
    }
 
    $read.Close()
    $read.Dispose()
    $scon.Dispose()
}
 
CountData -file "C:\files\file.txt" -ch "," -server "" -db ""

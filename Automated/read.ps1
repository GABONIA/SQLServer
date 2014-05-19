$scon = New-Object System.Data.SqlClient.SqlConnection
$scon.ConnectionString = "SERVER=SERVER\INSTANCE;DATABASE=DB;Integrated Security=true"

$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.Connection = $scon
$cmd.CommandText = "SELECT Value FROM Table"

$scon.Open()
$sqlread = $cmd.ExecuteReader()

while ($sqlread.Read())
{
    $value = $sqlread.GetValue(0)
}


$sqlread.Close()
$sqlread.Dispose()
$scon.Close()

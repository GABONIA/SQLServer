Function AlterTableName ($server, $database, $search, $new)
{
    Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    $serv = New-Object Microsoft.SqlServer.Management.Smo.Server("$server")
    $db = $serv.Databases["$database"]
    $table = $db.Tables["$search"]
 $cnt = 0
 
 foreach ($tab in $db.Tables)
 {
  $t = $tab.Name
  if ($t -like "*$search*")
  {
   $cnt++
  }
 }

    if ($table.Name -eq $null)
    {
        Write-Host "Table not found."
    }
    elseif ($cnt -eq 1)
    {
        $table.Rename("$new")

        foreach ($proc in $db.StoredProcedures | Where-Object {$_.IsSystemObject -eq $false})
        {
            $proc.TextBody = $proc.TextBody.Replace("$search", "$new")
            $proc.Alter()
        }
 
        foreach ($view in $db.Views | Where-Object {$_.IsSystemObject -eq $false})
        {
            $view.TextBody = $view.TextBody.Replace("$search", "$new")
            $view.Alter()
        }
    }
 else
 {
  Write-Host "Warning: multiple tables with a similar name/naming convention."
 }
}

AlterTableName -server "" -database "" -search "" -new ""



Function DocumentEnvironmentVp1 ($title, $htmlfile, $server)
{
  ## Version .1
  $write = New-Object System.IO.StreamWriter("$htmlfile")
  Add-Type -Path "C:\Program Files\Microsoft SQL Server\110\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
  $serv = New-Object Microsoft.SqlServer.Management.Smo.Server("$server")
  
  $open = "<p><table class='tab'>"
  $close = "</table></p>"
  $tableheadop = "<p><tr><td><b>"
  $tableheadcl = "</b></td></tr></p>"
  $css = "<style>
  .tab table, td, th {border:1px solid lightskyblue;}
  .tab th {background:darkblue; color:white;}
  .tab tr:nth-child(odd) {background:lightskyblue}
  </style>"
  
  $write.WriteLine("<html><head><title>" + $title + "</title>" + $css + "</head><body>")
  
  foreach ($db in $serv.Databases | Where-Object {$_.IsSystemObject -eq $false})
  {
      $d = $db.Name
      $write.WriteLine("<p><h3><b>" + $d + "</b></h3></p>")
  
      $pcnt = 0
      $fcnt = 0
  
      foreach ($proc in $db.StoredProcedures | Where-Object {$_.IsSystemObject -eq $false})
      {
          $pcnt++
      }
  
      $write.WriteLine($open)
      $write.WriteLine($tableheadop + "User Stored Procedures" + $tableheadcl)
      $write.WriteLine("<tr><td>" + $pcnt.ToString() + "</td></tr>")
      $write.WriteLine($close)
  
      foreach ($fun in $db.UserDefinedFunctions | Where-Object {$_.IsSystemObject -eq $false})
      {
          $fcnt++
      }
  
      $write.WriteLine($open)
      $write.WriteLine($tableheadop + "User Functions" + $tableheadcl)
      $write.WriteLine("<tr><td>" + $fcnt.ToString() + "</td></tr>")
      $write.WriteLine($close)
  
      $pcnt = 0
      $fcnt = 0
      
      foreach ($tb in $db.Tables | Where-Object {$_.IsSystemObject -eq $false})
      {
          $t = $tb.Name
          $write.WriteLine($open + $tableheadop + $t + $tableheadcl)
  
          foreach ($col in $tb.Columns)
          {
              $c = $col.Name
              $write.WriteLine("<tr><td>" + $c + "</td></tr>")
          }
          $write.WriteLine($close)
      }
  }
  
  $write.WriteLine("</body></html>")
  $write.Close()
  $write.Dispose()
}

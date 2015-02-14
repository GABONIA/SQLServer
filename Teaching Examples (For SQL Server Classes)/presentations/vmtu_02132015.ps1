###  
Function Loop-Databases ($server, $options = $null, $smolibrary = $null)
{
    
    if ($smolibrary -eq $null)
    {
        Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    }
    else
    {
        Add-Type -Path $smolibrary
    }

    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    if ($options -eq $null)
    {
        foreach ($db in $srv.Databases)
        {
            $db.Name
        }
    }
    elseif ($options.ToLower() -eq "s")
    {
        foreach ($db in $srv.Databases | Where-Object {$_.ID -gt 4})
        {
            $db.Name
        }
    }
    elseif ($options.ToLower() -eq "temp")
    {
        foreach ($db in $srv.Databases | Where-Object {$_.Name -ne "tempdb"})
        {
            $db.Name
        }
    }
    else
    {
        foreach ($db in $srv.Databases | Where-Object {$_.Name -eq "$options"})
        {
            $db
        }
    }

}

Loop-Databases -server "TIMOTHY\SQLEXPRESS"

Loop-Databases -server "TIMOTHY\SQLEXPRESS" -options "S"

Loop-Databases -server "TIMOTHY\SQLEXPRESS" -options "CrashIt"

###  
Function Loop-Databases ($server, $options = $null, $smolibrary = $null)
{
    
    if ($smolibrary -eq $null)
    {
        Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    }
    else
    {
        Add-Type -Path $smolibrary
    }

    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    if ($options -eq $null)
    {
        foreach ($db in $srv.Databases)
        {
            $db.Name
        }
    }
    elseif ($options.ToLower() -eq "s")
    {
        foreach ($db in $srv.Databases | Where-Object {$_.ID -gt 4})
        {
            $db.Name
        }
    }
    elseif ($options.ToLower() -eq "temp")
    {
        foreach ($db in $srv.Databases | Where-Object {$_.Name -ne "tempdb"})
        {
            $db.Name
        }
    }
    else
    {
        foreach ($db in $srv.Databases | Where-Object {$_.Name -eq "$options"})
        {
            Write-Host "Database name:" $db.Name
            Write-Host "Database ID:" $db.ID
            Write-host "Last backup date:" $db.LastBackupDate
            Write-host "Mirroring partner:" $db.MirroringPartner
            Write-host "Created date:" $db.CreateDate
            Write-host "Primary file path:" $db.PrimaryFilePath
            Write-host "Model:" $db.RecoveryModel
        }
    }

}

Loop-Databases -server "TIMOTHY\SQLEXPRESS" -options "CrashIt"

###  
clear
Function Loop-ObjectsInDatabase ($server, $object, $databaseoptions = $null, $smolibrary = $null)
{
    
    if ($smolibrary -eq $null)
    {
        Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    }
    else
    {
        Add-Type -Path $smolibrary
    }

    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    if ($databaseoptions -eq $null)
    {
        foreach ($db in $srv.Databases)
        {
            foreach ($obj in $db.$object | Where-Object {$_.IsSystemObject -eq $false})
            {
                $obj.Name
            }
        }
    }
    elseif ($databaseoptions.ToLower() -eq "s")
    {
        foreach ($db in $srv.Databases | Where-Object {$_.ID -gt 4})
        {
            foreach ($obj in $db.$object | Where-Object {$_.IsSystemObject -eq $false})
            {
                $obj.Name
            }
        }
    }
    elseif ($databaseoptions.ToLower() -eq "temp")
    {
        foreach ($db in $srv.Databases | Where-Object {$_.Name -ne "tempdb"})
        {
            foreach ($obj in $db.$object | Where-Object {$_.IsSystemObject -eq $false})
            {
                $obj.Name
            }
        }
    }
    else
    {
        foreach ($db in $srv.Databases | Where-Object {$_.Name -eq "$databaseoptions"})
        {
            foreach ($obj in $db.$object | Where-Object {$_.IsSystemObject -eq $false})
            {
                $obj.Name
            }
        }
    }

}

Loop-ObjectsInDatabase -server "TIMOTHY\SQLEXPRESS" -object "StoredProcedures" -databaseoptions "CrashIt"

###  
Function Loop-Objects ($server, $database, $object, $smolibrary = $null)
{
    if ($smolibrary -eq $null)
    {
        Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    }
    else
    {
        Add-Type -Path $smolibrary
    }

    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    foreach ($obj in $srv.Databases["$database"].$object | Where-Object {$_.IsSystemObject -eq $false})
    {
        $obj.Name
    }
}

Loop-Objects -server "TIMOTHY\SQLEXPRESS" -database "CrashIt" -object "StoredProcedures"
Loop-Objects -server "TIMOTHY\SQLEXPRESS" -database "CrashIt" -object "Tables"
Loop-Objects -server "TIMOTHY\SQLEXPRESS" -database "CrashIt" -object "Views"

###  
Function Find-ProcedureText ($server, $database, $object, $terms, $smolibrary = $null)
{
    if ($smolibrary -eq $null)
    {
        Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    }
    else
    {
        Add-Type -Path $smolibrary
    }

    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    foreach ($obj in $srv.Databases["$database"].$object | Where-Object {$_.IsSystemObject -eq $false})
    {
        $text = $obj.TextBody
        if ($text.Contains("$terms"))
        {
            Write-Host $obj.Name
            Write-Host $obj.TextBody
        }
    }
}

Find-ProcedureText -server "TIMOTHY\SQLEXPRESS" -database "CrashIt" -object "StoredProcedures" -terms "Haha"
Find-ProcedureText -server "TIMOTHY\SQLEXPRESS" -database "CrashIt" -object "StoredProcedures" -terms "EXECUTE"
Find-ProcedureText -server "TIMOTHY\SQLEXPRESS" -database "CrashIt" -object "StoredProcedures" -terms "Thislinedoesntexistinaprocedure"

###  
Function Find-Tables ($server, $database, $object, $terms, $smolibrary = $null)
{
    $nl = [Environment]::NewLine   
    if ($smolibrary -eq $null)
    {
        Add-Type -Path "C:\Program Files (x86)\Microsoft SQL Server\100\SDK\Assemblies\Microsoft.SqlServer.Smo.dll"
    }
    else
    {
        Add-Type -Path $smolibrary
    }

    $srv = New-Object Microsoft.SqlServer.Management.SMO.Server($server)

    foreach ($obj in $srv.Databases["$database"].$object | Where-Object {$_.IsSystemObject -eq $false})
    {
        $array += $obj.Name
    }


}

Find-Tables -server "TIMOTHY\SQLEXPRESS" -database "AdventureWorks" -object "Tables"

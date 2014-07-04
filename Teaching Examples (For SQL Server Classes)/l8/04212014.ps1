Function RenameMoveFile($locationPath, $fileName, $extension, $archiveFolder)
{
    $date = Get-Date -uFormat "%Y%m%d"
    $old = $locationPath + $fileName + $extension
    $new = $locationPath + $fileName + "_" + $date + $extension
    $archiveFolder = $locationPath + $archiveFolder + "\"
    Rename-Item $old $new
    Move-Item $new $archiveFolder
}

RenameMoveFile -locationPath "" -fileName "" -extension "" -archiveFolder ""

-- See tranf.
Function MultipleStrings ($string)
{
    $nl = [Environment]::NewLine
    $string*3
}

MultipleStrings -string

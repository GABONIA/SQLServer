## Catch escape character
## Note that [System.Text.RegularExpressions.Regex] is also a parameter
$regex = [System.Text.RegularExpressions.Regex]::Matches($string, [System.Text.RegularExpressions.Regex]::Escape('$ch'))

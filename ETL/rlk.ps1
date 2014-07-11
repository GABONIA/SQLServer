## Simple rep. example
Function replace_WithLink($file, $question, $link)
{
  $x = Get-Content $file
  $x = $x.Replace("$question", "$link")
  $x | Out-File $file -Force
}

replace_WithLink -file '' -question '' -link '<a href="" target="_blank"></a>

Function Gmail_SendMail ($from, $to, $password, $title, $file, $smtp_server = $null, $attachment = $null)
{
    $u = $from.Substring(0,$from.IndexOf("@"))

    if ($smtp_server -eq $null)
    {
        $smtp_server = "smtp.gmail.com" 
    }

    $smtp = New-Object Net.Mail.SmtpClient($smtp_server, 587) 
    $smtp.EnableSsl = $true 
    $smtp.Credentials = New-Object System.Net.NetworkCredential($u, $password)
    
    $body = Get-Content $file
    $email = New-Object Net.Mail.MailMessage
    $email.From = $from
    $email.To.Add($to)
    $email.Subject = $title
    $email.Body = $body

    if ($attachment -ne $null)
    {
        $email.Attachments.Add($attachment)
    }

    $smtp.Send($email)
    $smtp.Dispose()
}

Gmail_SendMail -from "" -to "" -password "" -title "" -file "" -attachment ""

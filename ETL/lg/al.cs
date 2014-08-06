public static class Alerts
{
    public static bool TextAlert(string body, string textAlert = null)
    {
        // If established:
        if (textAlert == null)
        {
            textAlert = "";  // Default
        }

        bool check = false;
        string smtp_sender = "";
        string from = "";
        SmtpClient smtpcl = new SmtpClient(smtp_sender);

        if (body.Count() > 140)
        {
            string b;
            int start = 0;
            float bodycount = (body.Count() / 140);
            if (((body.Count() % 140) != 0))
            {
                for (int i = 1; i <= (bodycount + 1); i++)
                {
                    if (i == (bodycount + 1))
                    {
                        b = body.Substring(start, (body.Count() - start));
                    }
                    else
                    {
                        b = body.Substring(start, 140);
                    }

                    try
                    {
                        smtpcl.Send(from, textAlert, "", b);
                        check = true;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Text alert failed.  Error: " + ex.ToString());
                    }
                    start = start + 140;
                }
            }
            else
            {
                for (int i = 1; i <= bodycount; i++)
                {
                    b = body.Substring(start, 140);
                    try
                    {
                        smtpcl.Send(from, textAlert, "", b);
                        check = true;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Text alert failed.  Error: " + ex.ToString());
                    }
                    start = start + 140;
                }
            }
        }
        else
        {
            try
            {
                smtpcl.Send(from, textAlert, "", body);
                check = true;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Text alert failed.  Error: " + ex.ToString());
            }
        }

        smtpcl.Dispose();
        return check;
    }
    public static bool EmailAlert (string to_add, string from_add, string em_sub, string em_bd, string smtp_server, string sAttachment = null)
    {
        int i = 0;
        string[] sTempA = null;
        SmtpClient SmtpMail = new SmtpClient();
        MailMessage MailMsg = new MailMessage();

        sTempA = to_add.Split(',');

        try
        {
            for (i = 0; i < (sTempA.Length -1); i++)
            {
                MailMsg.To.Add(new MailAddress(sTempA[i]));
            }

            MailMsg.From = new MailAddress(from_add);
            MailMsg.Subject = em_sub.Trim();
            MailMsg.Body = em_bd.Trim() + Environment.NewLine;

            if (sAttachment != null)
            {
                Attachment MsgAttach = new Attachment(sAttachment);
                MailMsg.Attachments.Add(MsgAttach);
                SmtpMail.Host = smtp_sender;
                SmtpMail.Send(MailMsg);
                MsgAttach.Dispose();
            }
            else
            {
                SmtpMail.Host = smtp_sender;
                SmtpMail.Send(MailMsg);
            }
            return true;
        }
        catch (Exception ex)
        {
            sTempA = null;
            SmtpMail.Dispose();
            MailMsg.Dispose();
            //Console.WriteLine(ex);
            return false;
        }
    }
}

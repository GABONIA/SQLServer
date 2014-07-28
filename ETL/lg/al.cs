public static class Alerts
{
    public static bool TextAlert(string body, string textAlert = null)
    {
        bool check = false;
        // If established:
        if (textAlert == null)
        {
            textAlert = ""; // Default
        }
        string smtp_sender = "";
        string from = "";
        SmtpClient smtpcl = new SmtpClient(smtp_sender);

        try
        {
            smtpcl.Send(from, textAlert, "", body);
            check = true;
        }
        catch (Exception ex)
        {
            Console.WriteLine("Text alert failed.  Error: " + ex.ToString());
        }
        finally 
        {
            smtpcl.Dispose();
        }
        return check;
    }
    public static bool EmailAlert(string emailAlert)
    {
        bool check = false;

        return check;
    }
}

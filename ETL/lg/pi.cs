public class APIs
{
    public static int downloadFTPFiles(string ftpsite, string filter, string downloadpath)
    {
        string ftpfile = "";
        int cnt = 0;
        StreamReader read = null;
        FtpWebRequest fareq = (FtpWebRequest)WebRequest.Create(ftpsite);
        fareq.Method = WebRequestMethods.Ftp.DownloadFile;

        fareq.Method = WebRequestMethods.Ftp.ListDirectory;
        FtpWebResponse resp = (FtpWebResponse)fareq.GetResponse();

        read = new StreamReader(resp.GetResponseStream());
        string ln = read.ReadLine();
        while (ln != null)
        {
            if (ln.Contains(filter) == true)
            {
                ftpfile = ftpsite + ln;
                using (WebClient wbc = new WebClient())
                {
                    string newdo = downloadpath + ln;
                    wbc.DownloadFile(ftpfile, newdo);
                }
            }
            ln = read.ReadLine();
        }
        read.Close();
        read.Dispose();
        return cnt;
    }
}

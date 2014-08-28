using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Timers;
using System.Threading;
using System.Threading.Tasks;
// SQL Server SDK
// Microsoft.SqlServer.ConnectionInfo.dll
// Microsoft.SqlServer.SqlEnum.dll
// Microsoft.SqlServer.Management.Sdk.Sfc.dll
// Microsoft.SqlServer.Smo.dll
using System.Net.Mail;
using Microsoft.SqlServer.Management.Smo;
// Quartz
using Quartz;


namespace DBA_ETL_Logger
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.ReadLine();
        }
    }


    public static class Files
    {
        public static string getContent_Except(string file, string exc)
        {
            System.Text.StringBuilder data = new System.Text.StringBuilder();
            using (System.IO.StreamReader readfile = new System.IO.StreamReader(file, Encoding.UTF8))
            {
                string ln;
                while ((ln = readfile.ReadLine()) != null)
                {
                    if ((ln.TrimStart().Substring(0, 1)) != exc)
                    {
                        data.AppendLine(ln);
                    }
                }
                return data.ToString();
            }
        }
        
        public static string getContent(string file)
        {
            string data = "";
            using (System.IO.StreamReader readfile = new System.IO.StreamReader(file, Encoding.UTF8))
            {
                data = readfile.ReadToEnd();
            }
            return data;
        }
    }


    public static class Alerts
    {
        // wr_ue_nal
        public static bool TextAlert(string body, string smtp_sender, string textAlert = null)
        {
            DateTime now = DateTime.Now;
            // If established:
            if (textAlert == null)
            {
                // default
                textAlert = "";
            }

            if (smtp_sender == null)
            {
            	// default
            	smtp_sender = "";
            }
            
            bool check = false;
           
            // edit:
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
        public static bool EmailAlert(string emailAlert)
        {
            bool check = false;

            return check;
        }
    }


    public static class Connections
    {
        public static Server ServerConnect(string srv)
        {
            Server server = new Server(srv);
            return server;
        }
        public static SqlConnection Connect(string srv, string db)
        {
            SqlConnection scon = new SqlConnection(@"Data Source=" + srv + ";Initial Catalog=" + db + ";integrated security=true");
            scon.Open();
            return scon;
        }
    }


    public class SqlOperations
    {
        public static bool ExecuteCommand(string srv, string db, string cmdText)
        {
            using (var scon = Connections.Connect(srv, db))
            {
                SqlCommand cmd = new SqlCommand(cmdText, scon);
                cmd.CommandTimeout = 0;
                bool b = false;
                try
                {
                    cmd.ExecuteNonQuery();
                    b = true;
                }
                catch
                {
                    b = false;
                }
                finally
                {
                    scon.Close();
                    scon.Dispose();
                }
                return b;
            }
        }
        public static bool BuildETLLogTable(string srv, string db, string tbName)
        {
            string ETLTable = "IF OBJECT_ID('" + tbName + "') IS NULL BEGIN CREATE TABLE " + tbName + " () END";
            bool es;
            try
            {
                using (var scon = Connections.Connect(srv, db))
                {
                    SqlCommand buildtable = new SqlCommand(ETLTable, scon);
                    buildtable.ExecuteNonQuery();
                    scon.Close();
                    scon.Dispose();
                }
                es = true;
            }
            catch
            {
                es = false;
            }
            return es;
        }
        public static bool BuildDBALogTable(string srv, string db, string tbName)
        {
            string DBATable = "IF OBJECT_ID('" + tbName + "') IS NULL BEGIN CREATE TABLE " + tbName + " () END";
            bool ds;
            try
            {
                using (var scon = Connections.Connect(srv, db))
                {
                    SqlCommand buildtable = new SqlCommand(DBATable, scon);
                    buildtable.ExecuteNonQuery();
                    scon.Close();
                    scon.Dispose();
                }
                ds = true;
            }
            catch
            {
                ds = false;
            }
            return ds;
        }
        public static string IssueCheckpoints(string stringsrv)
        {
            /*
            SELECT
	            CASE 
		            WHEN [Checkpoint End] IS NULL THEN 'Checkpoint started: '
		            ELSE 'Checkpoint finished: '
	            END AS [Status]
	            , CASE 
		            WHEN [Checkpoint End] IS NULL THEN [Checkpoint Begin]
		            ELSE [Checkpoint End] 
	            END AS CheckpointTime
            FROM  fn_dblog(NULL, NULL) 
            WHERE Operation IN ('LOP_BEGIN_CKPT', 'LOP_END_CKPT')
            */
            string message = "";
            Server srv = Connections.ServerConnect(stringsrv);
            foreach (Database db in srv.Databases)
            {
                if ((db.IsSystemObject == false) || (db.RecoveryModel.ToString() == "Simple"))
                {
                    string dbName = db.Name.ToString();
                    try
                    {
                        SqlOperations.ExecuteCommand(stringsrv, dbName, "CHECKPOINT;");
                        message = "Checkpoint issued on " + dbName + ".";
                    }
                    catch (Exception ex)
                    {
                        message = "Checkpoint failed on " + dbName + "." + "\n" + "Exception: " + ex.ToString();
                    }
                }
            }
            return message;
        }
        public static int IssueCheckpoints_CertainDBs(string stringsrv, List<String> dbs)
        {
            int x = 0;
            foreach (string db in dbs)
            {
                try
                {
                    SqlOperations.ExecuteCommand(stringsrv, db, "CHECKPOINT;");
                    Console.WriteLine("Checkpoint issued on " + db + ".  Verify if this stops error log issues.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Checkpoint failed on " + db + ".  Exception: {0}.", ex);
                    x++;
                }
            }
            return x;
        }
        public static string LargeUnCompressedTables(string stringsrv, double gig)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            foreach (Database db in srv.Databases)
            {
                if (db.IsSystemObject == false)
                {
                    foreach (Table tb in db.Tables)
                    {
                        if ((tb.DataSpaceUsed / (1024 * 1024)) > gig && ((tb.PhysicalPartitions[0].DataCompression).ToString() == "None"))
                        {
                            Console.WriteLine("Database: {0}, Table: {1}", db.Name, tb.Name);
                        }
                    }
                }
            }
            return "Finished checking for large, uncompressed tables.";
        }
        public static string LargeUnCompressedIndexes(string stringsrv, double gig)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            foreach (Database db in srv.Databases)
            {
                if (db.IsSystemObject == false)
                {
                    foreach (Table tb in db.Tables)
                    {
                        foreach (Index idx in tb.Indexes)
                        {
                            if ((idx.SpaceUsed / (1024 * 1024)) > gig && ((idx.PhysicalPartitions[0].DataCompression).ToString() == "None"))
                            {
                                Console.WriteLine("Database: {0}, Table: {1}, Index: {2}", db.Name, tb.Name, idx.Name);
                                //string rebuild = "ALTER INDEX " + idx.Name + " ON " + tb.Name + " REBUILD WITH (DATA_COMPRESSION = PAGE)";
                                //Console.WriteLine(rebuild);
                                //SqlOperations.ExecuteCommand(stringsrv,db.Name,rebuild);
                            }
                        }
                    }
                }
            }
            return "Finished checking for large, uncompressed indexes.";
        }
        public static int NonSystemDBsIssueCommand(string stringsrv, string cmdText)
        {
            int x = 0;
            Server srv = Connections.ServerConnect(stringsrv);
            foreach (Database db in srv.Databases)
            {
                if (db.IsSystemObject == false)
                {
                    string dbName = db.Name;
                    try
                    {
                        SqlOperations.ExecuteCommand(stringsrv, dbName, cmdText);
                        Console.WriteLine("Command succeeded on " + dbName + ".");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Command failed on " + dbName + ".  Exception: {0}.", ex);
                        x++;
                    }
                }
            }
            return x;
        }
        public static string ActiveTransactionDBs(string stringsrv)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            return srv.NumberOfLogFiles.ToString();
        }
        public static string ReadEventLog_Recent(string stringsrv, string logtype, int hrs)
        {
            EventLog evlog = new EventLog(logtype, stringsrv);
            DateTime now = DateTime.Now;
            foreach (EventLogEntry ele in evlog.Entries)
            {
                if ((ele.TimeGenerated > now.AddHours(-hrs) ) && ( ele.Source.ToLower().Contains("sql")))
                {
                    Console.WriteLine(ele.Message + " (" + ele.TimeGenerated + ")");
                }
            }
            return "\n" + "Complete";
        }
        public static string ReadSQLLog_Recent(string stringsrv)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            DataTable dt = srv.ReadErrorLog();
            foreach (DataRow row in dt.Rows)
            {
                DateTime colDate = Convert.ToDateTime(row["LogDate"]);
                string message = Convert.ToString(row["Text"]) + "\n";

                if ((colDate > DateTime.Now.AddMinutes(-60)) && (colDate < DateTime.Now))
                {
                    Console.WriteLine(message);
                }
            }
            return "\n" + "Complete.";
        }
        public static string ReadSQLLog_LastTen(string stringsrv)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            DataTable dt = srv.ReadErrorLog();
            foreach (DataRow row in dt.Rows)
            {
                DateTime colDate = Convert.ToDateTime(row["LogDate"]);
                string message = Convert.ToString(row["Text"]) + "\n";

                if ((colDate > DateTime.Now.AddMinutes(-10)) && (colDate < DateTime.Now))
                {
                    Console.WriteLine(message);
                }
            }
            return "\n" + "Complete.";
        }
        public static List<String> ActiveTransactionSimpleDBs(string stringsrv)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            DataTable dt = srv.ReadErrorLog();
            List<string> dbs = new List<string>();
            string db;
            foreach (DataRow row in dt.Rows)
            {
                DateTime colDate = Convert.ToDateTime(row["LogDate"]);
                string message = Convert.ToString(row["Text"]) + "\n";

                if ((colDate > DateTime.Now.AddMinutes(-30)) && (colDate < DateTime.Now))
                {
                    if (message.Contains("'ACTIVE_TRANSACTION'"))
                    {
                        db = message.Substring(message.IndexOf("'") + 1, (message.IndexOf("' is full") - (message.IndexOf("'") + 1)));
                        if (!dbs.Contains(db))
                        {
                            dbs.Add(db);
                        }
                    }
                }
            }
            return dbs;
        }
        public static string CheckDBErrors(string stringsrv)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            DataTable dt = srv.ReadErrorLog();
            string status = "No CHECKDB errors for " + srv.Name + ".";
            foreach (DataRow row in dt.Rows)
            {
                DateTime colDate = Convert.ToDateTime(row["LogDate"]);
                string message = Convert.ToString(row["Text"]) + "\n";

                if ((colDate > DateTime.Now.AddMinutes(-1440)) && (colDate < DateTime.Now))
                {
                    if ((message.Contains("DBCC CHECKDB")) && !message.Contains("found 0 errors"))
                    {
                        Alerts.TextAlert(message);
                        status = "E.";
                    }
                }
            }

            if (status == "E")
            {
                status = "Review SQL Server error logs for server " + srv.Name;
            }
            Alerts.TextAlert(status);
            return status;
        }
        public static string MultipleLogins (string stringsrv, int no)
        {
            int cnt = 0;
            string status = "Logins cleared.";
            Server srv = Connections.ServerConnect(stringsrv);
            DataTable dt = srv.ReadErrorLog();
            foreach (DataRow row in dt.Rows)
            {
                DateTime colDate = Convert.ToDateTime(row["LogDate"]);
                string message = Convert.ToString(row["Text"]) + "\n";

                if ((colDate > DateTime.Now.AddMinutes(-10)) && (colDate < DateTime.Now))
                {
                    if (message.Contains("Login failed"))
                    {
                        cnt++;
                    }
                }
            }

            if (cnt >= no)
            {
                Alerts.TextAlert(no.ToString() + " logins failed in the past ten minutes.");
                status = no.ToString() + " logins failed in the past ten minutes.";
            }
            return status;
        }
        public static List<String> LowFreeSpaceDBs(string stringsrv, double lowspace)
        {
            Server srv = Connections.ServerConnect(stringsrv);
            List<string> lowspacedbs = new List<string>();
            decimal total;
            decimal free;
            foreach (Database db in srv.Databases)
            {
                total = Convert.ToDecimal(db.Size) /(1024);
                free = Convert.ToDecimal(db.SpaceAvailable) / (Convert.ToDecimal(1024 * 1024));
                if ((Convert.ToDouble(free/total)) < lowspace)
                {
                    Console.WriteLine(db.Name);
                    lowspacedbs.Add(db.Name);
                }
            }
            return lowspacedbs;
        }
        public static int ApplySQLFilesToServer(string stringsrv, string filepath, string onedb = null)
        {
            int x = 0;
            Server srv = Connections.ServerConnect(stringsrv);
            string[] sqlfiles = Directory.GetFiles(filepath, "*.sql");
            
            foreach (string fi in sqlfiles)
            {
                if (onedb == null)
                {
                    foreach (Database db in srv.Databases)
                    {
                        if (db.IsSystemObject == false)
                        {
                            string dbName = db.Name;
                            try
                            {
                                SqlOperations.ExecuteCommand(stringsrv, dbName, Files.FileAsString(fi));
                                Console.WriteLine("Command succeeded on " + dbName + ".");
                                SqlOperations.ReturnConfirmation(stringsrv, dbName);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine("Command failed on " + dbName + ".  Exception: {0}.", ex);
                                x++;
                            }
                        }
                    }
                }
                else
                {
                    try
                    {
                        SqlOperations.ExecuteCommand(stringsrv, onedb, Files.FileAsString(fi));
                        Console.WriteLine("Command succeeded on " + onedb + ".");
                        SqlOperations.ReturnConfirmation(stringsrv, onedb);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Command failed on " + onedb + ".  Exception: {0}.", ex);
                        x = 1;
                    }
                }
            }
            return x;
        }
        public static int ApplySQLFilesToMultipleServers(string[] stringsrvs, string filepath, string onedb = null)
        {
            int x = 0;
            foreach (string stringsrv in stringsrvs)
            {
                x = SqlOperations.ApplySQLFilesToServer(stringsrv, filepath, onedb);
            }
            return x;
        }
        public static string CountUncompressedTablesAndIndexes(string stringsrv, string dbName)
        {
            int idx_cnt = 0, tb_cnt = 0;
            Server srv = Connections.ServerConnect(stringsrv);
            Database db = srv.Databases[dbName];
            if (db.IsSystemObject == false)
            {
                foreach (Table tb in db.Tables)
                {
                    if ((tb.PhysicalPartitions[0].DataCompression).ToString() == "None")
                    {
                        tb_cnt++;
                    }

                    foreach (Index idx in tb.Indexes)
                    {
                        if ((idx.PhysicalPartitions[0].DataCompression).ToString() == "None")
                        {
                            idx_cnt++;
                        }
                    }
                }
            }
            string uncompressedtbsindxs = "\t" + "Uncompressed tables: " + tb_cnt.ToString() + "; uncompressed indexes: " + idx_cnt.ToString() + ".";
            return uncompressedtbsindxs;
        }
        public static decimal DirSize (string dir, string measurement)
        {
            decimal size = 0;
            decimal b = 1024;
            string[] all = Directory.GetFiles(dir, "*df");
            foreach (string d in all)
            {
                FileInfo fsize = new FileInfo(d);
                size += Convert.ToDecimal(fsize.Length);
            }

            if (measurement == "GIG")
            {
                size = size / (b * b * b);
            }
            else if (measurement == "MB")
            {
                size = size / (b * b);
            }

            return size;
        }
        public static string ReturnConfirmation(string stringsrv, string db = null)
        {
            if (db == null)
            {
                db = "master";
            }
            string confirmation = "";
            using (var scon = Connections.Connect(stringsrv, db))
            {
                SqlCommand retcon = new SqlCommand("SELECT CAST(DB_ID() AS VARCHAR(4)) + '_' + CAST(NEWID() AS VARCHAR(50)) + '_' + CONVERT(VARCHAR(8),GETDATE(),112)", scon);
                SqlDataReader readSQL = retcon.ExecuteReader();
                while (readSQL.Read())
                {
                    confirmation += readSQL.GetString(0);
                }
                scon.Close();
                scon.Dispose();
            }
            return confirmation;
        }
    }
}

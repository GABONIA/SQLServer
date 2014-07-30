using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
// SQL Server SDK
// Microsoft.SqlServer.ConnectionInfo.dll
// Microsoft.SqlServer.SqlEnum.dll
// Microsoft.SqlServer.Management.Sdk.Sfc.dll
// Microsoft.SqlServer.Smo.dll
using Microsoft.SqlServer.Management.Smo;


namespace DBA_ETL_Logger
{
    class Program
    {
        static void Main(string[] args)
        {
            // Tested: 9
            // [x] UPST
            // [] BK
            // [x] Em
            // [x] Txt
            // [] Mult sv
            // [x] CDB
            Console.ReadLine();
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
        public static int IssueCheckpoints(string stringsrv)
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
            int x = 0;
            Server srv = Connections.ServerConnect(stringsrv);
            foreach (Database db in srv.Databases)
            {
                if ((db.IsSystemObject == false) || (db.RecoveryModel.ToString() == "Simple"))
                {
                    string dbName = db.Name.ToString();
                    try
                    {
                        SqlOperations.ExecuteCommand(stringsrv, dbName, "CHECKPOINT;");
                        Console.WriteLine("Checkpoint issued on " + dbName + ".");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Checkpoint failed on " + dbName + ".  " + ex.ToString());
                        x++;
                    }
                }
            }
            return x;
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
                    string srvName = srv.Name;
                    try
                    {
                        SqlOperations.ExecuteCommand(srvName, dbName, cmdText);
                        Console.WriteLine("Command succeeded on " + dbName + ".");
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Command failed on " + dbName + ".  Exception: {0}", ex);
                        x++;
                    }
                }
            }
            return x;
        }
    }
}

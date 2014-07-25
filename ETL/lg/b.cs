using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
// SQL Server SDK
using Microsoft.SqlServer.Management.Smo;

namespace ben
{
    class Program
    {
        static void Main(string[] args)
        {
        }
    }

    public static class Connections
    {
        public static Server ServerConnect(string srv)
        {
            Server server = new Server(srv);
            return server;
        }
        public static SqlConnection Connection(string srv, string db)
        {
            SqlConnection scon = new SqlConnection(@"Data Source=" + srv + ";Initial Catalog=" + db + ";integrated security=true");
            scon.Open();
            return scon;
        }
    }
}

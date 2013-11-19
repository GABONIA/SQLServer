// How long does this take?

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace ConsoleFasty
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Enter the account number");
            string answer = Console.ReadLine();

            using (var scon = Connections.Connect())
            {
                // Edit below stored procedure value
                SqlCommand checkit = new SqlCommand("EXECUTE stp_OurStoredProcedure @p", scon);
                checkit.Parameters.Add(new SqlParameter("@p", answer));
                SqlDataReader dread = checkit.ExecuteReader();

                while (dread.Read())
                {
                    for (int i = 0; i < dread.FieldCount; i++)
                    {
                        Console.WriteLine(dread[i] + " ");
                    }
                }

                dread.Close();
                scon.Close();
            }
            Console.WriteLine("How fast was that?");
            Console.ReadLine();
        }
    }

    public static class Connections
    {
        public static SqlConnection Connect()
        {
            // Edit below two values
            string server = "SERVER\\INSTANCE";
            string database = "Database";
            SqlConnection scon = new SqlConnection();
            scon.ConnectionString = "integrated security=SSPI;data source=" + server + ";persist security info=False;initial catalog=" + database + "";
            scon.Open();
            return scon;
        }
    }
}

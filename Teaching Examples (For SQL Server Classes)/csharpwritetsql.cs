/*
-- TSQL: 

CREATE TABLE tbSharp(
	One VARCHAR(10),
	Two VARCHAR(10),
	Three VARCHAR(10),
	Four VARCHAR(10),
	Five VARCHAR(10)
)

SELECT *
FROM tbSharp

DROP TABLE tbSharp

*/

/*

// C#

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Data.SqlClient;

namespace ReadFile
{
    class Program
    {
        static void Main(string[] args)
        {
            string fle = @"C:\Files\file.txt";

            var all = File.ReadAllLines(fle);

            for (int i = 1; i < all.Length; i++)
            {
                var cols = all[i].Split(',');
                using (var scon = Utilities.Connect())
                {
                    SqlCommand ins = new SqlCommand("INSERT INTO tbSharp SELECT @1,@2,@3,@4,@5", scon);
                    ins.Parameters.Add(new SqlParameter("@1", cols[0]));
                    ins.Parameters.Add(new SqlParameter("@2", cols[1]));
                    ins.Parameters.Add(new SqlParameter("@3", cols[2]));
                    ins.Parameters.Add(new SqlParameter("@4", cols[3]));
                    ins.Parameters.Add(new SqlParameter("@5", cols[4]));
                    ins.ExecuteNonQuery();
                    scon.Close();
                }

            }
            
            Console.WriteLine("\n" + "\t" + "File read.");
            Console.ReadLine();
        }
    }

    public static class Utilities
    {
        public static SqlConnection Connect()
        {
            SqlConnection scon = new SqlConnection(@"integrated security=SSPI;data source=SERVER\INST;persist security info=False;initial catalog=Database");
            scon.Open();
            return scon;
        }
    }
}


*/

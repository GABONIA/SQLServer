/*
-- Non-Proc

CREATE TABLE Pictures(
  Picture VARBINARY(MAX)
)

CREATE PROCEDURE stp_AddImage
@f VARCHAR(1000)
AS
BEGIN

  DECLARE @s NVARCHAR(MAX)
  SET @s = 'INSERT INTO Pictures (Picture)
    SELECT *
    FROM OPENROWSET(BULK N''' + @f + ''', SINGLE_BLOB) mf'
    
  EXEC sp_executesql @s

END


*/

-- C# Loop

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data.SqlClient;

namespace PictureInsert
{
    class Program
    {
        static void Main(string[] args)
        {
            string dir = @"F:\Images\";
            string[] fs = Directory.GetFiles(dir);

            foreach (string f in fs)
            {
                if (f.Trim().EndsWith(".png") | f.Trim().EndsWith(".jpg"))
                {
                    using (var scon = Connection.Connect())
                    {
                        SqlCommand addpic = new SqlCommand("EXECUTE stp_AddImage @p", scon);
                        addpic.Parameters.AddWithValue("@p", f);
                        addpic.ExecuteNonQuery();
                        scon.Close();
                    }
                    Console.WriteLine("Image " + f + " added." + "\n");
                }

            }
            Console.ReadLine();
        }
    }

    public static class Connection
    {
        public static SqlConnection Connect()
        {
            SqlConnection scon = new SqlConnection();
            scon.ConnectionString = "integrated security=SSPI;data source=SERVER;persist security info=False;initial catalog=DATABASE";
            scon.Open();
            return scon;
        }
    }
}


/* Test program */
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestingDataTables
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string[]> myList = new List<string[]>();
            /// Add columns:
            myList.Add(new string[] { "Column1", "Column2", "Column3" });
            /// Dynamic increasing rows for test:
            string one, two, three;

            /// Build some test varchar data:
            for (int i = 0; i < 2000; i++)
            {
                one = "Row" + i.ToString() + "Col1";
                two = "Row" + i.ToString() + "Col2";
                three = "Row" + i.ToString() + "Col3";

                myList.Add(new string[] { one, two, three });
            }

            /// Create data table from the string list
            DataTables bulkCopyData = new DataTables(myList);
            DataTable myNewDataTable = bulkCopyData.ConvertStringListToDataTable(myList);

            
            string now = Convert.ToString(DateTime.Now);
            Console.WriteLine("Bulk copying data " + now + " ...");

            /// The first row is columns, so before bulk copying the test data, we'll remove the rows:
            myNewDataTable.Rows.Remove(myNewDataTable.Rows[0]);
            /// Now bulk copy test records:
            bulkCopyData.CopyDataTable(myNewDataTable, "myTableBulkCopy");
            
            string done = Convert.ToString(DateTime.Now);
            Console.WriteLine("Finished bulk copying records" + done + " ...");
            Console.ReadLine();
        }
    }
}

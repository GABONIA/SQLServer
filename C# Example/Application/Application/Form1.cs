using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace WindowsFormsApplication16
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection();
            con.ConnectionString = "integrated security=true;data source=Timothy\\sqlexpress;" + "persist security info=False;initial catalog=Application";
      
            con.Open();
            SqlCommand myCom = new SqlCommand("EXECUTE InsertBasicVerification @1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12", con);
            myCom.Parameters.Add(new SqlParameter("@1", Convert.ToString(txt1.Text)));
            myCom.Parameters.Add(new SqlParameter("@2", Convert.ToString(txt2.Text)));
            myCom.Parameters.Add(new SqlParameter("@3", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@4", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@5", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@6", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@7", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@8", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@9", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@10", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@11", Convert.ToString(txt3.Text)));
            myCom.Parameters.Add(new SqlParameter("@12", Convert.ToString(txt3.Text)));
            myCom.ExecuteNonQuery();
            con.Close();

            foreach (var co in Controls)
            {
                if (co is TextBox)
                {
                    ((TextBox)co).Text = String.Empty;
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}

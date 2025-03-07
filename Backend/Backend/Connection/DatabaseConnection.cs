using MySql.Data.MySqlClient;
using SqlSugar;
using Microsoft.AspNetCore.Mvc;
using System.Drawing.Printing;

namespace Backend.Connection
{
    public class DatabaseConnection
    {
        public static string constr = "Database=test1;Data Source=43.142.90.90;User Id=Levist;Password=!888pyz;port=3306";
        public SqlSugarClient sqlORM = null;
        public bool Conn()
        {
            try
            {
                MySqlConnection con = new MySqlConnection(constr);
                con.Open();
       

                sqlORM = new SqlSugarClient(new ConnectionConfig()
                {
                    ConnectionString = constr,
                    DbType = DbType.MySql,
                    IsAutoCloseConnection = true,
                    MoreSettings = new ConnMoreSettings
                    {
                        DisableNvarchar = true,
                    },
                },
                db =>
                {
                    //调试SQL事件，可以删掉
                    db.Aop.OnLogExecuting = (sql, pars) =>
                    {
                        //Console.WriteLine(sql);//输出sql,查看执行sql
                    };
                }

                );
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return false;
            }
        }
    }
}

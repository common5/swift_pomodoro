using Microsoft.AspNetCore.Mvc;
using SqlSugar;
using Oracle.ManagedDataAccess.Client;
using Microsoft.AspNetCore.Identity;
using Backend.Connection;
using Backend.Models;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using Org.BouncyCastle.Utilities;

namespace Backend.Controllers
{
    
    public class LoginRequest
    {
        public string Account { get; set; }
        public string Password { get; set; }
    }
    public class RegisterRequest
    {
        public string Account { get; set; }
        public string Password { get; set; }
    }
    [ApiController]
    [Route("api/user")]
    public class UserController : ControllerBase
    {
        private const string salt = "I am salty";
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginRequest json)
        {
            
            string account = json.Account;
            string password = json.Password;
            Console.WriteLine("account=" + account);
            Console.WriteLine("password= " + password);

            DatabaseConnection db = new DatabaseConnection();
            if (db.Conn() == true)
            {
                try
                {
                    SqlSugarClient sql = db.sqlORM;
                    Func<string, string> gethash = x =>
                    {
                        string code = x + salt;
                        var tmp = ASCIIEncoding.ASCII.GetBytes(code);
                        var hash = SHA256.Create().ComputeHash(tmp);
                        StringBuilder builder = new StringBuilder();
                        foreach (byte b in hash)
                        {
                            builder.Append(b.ToString("x2")); // 使用"x2"格式化将字节转换为16进制
                        }
                        string hashcode = builder.ToString();
                        return hashcode;
                    };
                    var hash = gethash(password);
                    List<Usr> usrs = await sql.Queryable<Usr>().Where(it => it.account == account && it.password==hash).ToListAsync();

                    if (usrs.Count <= 0)
                    {
                        return Ok(new CustomResponse { ok = "no", message = "no such user" });
                    }
                    else
                    {
                        return Ok(new CustomResponse { ok = "yes", value = usrs[0].user_id });
                    }
                }
                catch(Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    return BadRequest("登录失败");
                }
            }
            else
            {
                Console.WriteLine("连接失败");
                return BadRequest();
            }
        }
        [HttpPost("Register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest json)
        {
            DatabaseConnection db = new DatabaseConnection();
            string account = json.Account;
            string password = json.Password;
            Console.WriteLine("account=" + account);
            Console.WriteLine("password= " + password);

            // 先查一遍数据库中是否有完全相同的(id,pswd)组
            if (db.Conn() == true)
            {
                try
                {
                    SqlSugarClient sql = db.sqlORM;
                    Func<string, string> gethash = x =>
                    {
                        string code = x + salt;
                        var tmp = ASCIIEncoding.ASCII.GetBytes(code);
                        var hash = SHA256.Create().ComputeHash(tmp);
                        StringBuilder builder = new StringBuilder();
                        foreach (byte b in hash)
                        {
                            builder.Append(b.ToString("x2")); // 使用"x2"格式化将字节转换为16进制
                        }
                        string hashcode = builder.ToString();
                        return hashcode;
                    };
                    Console.WriteLine("test1");
                    Console.WriteLine(gethash(password));
                    var tmp = gethash(password);
                    List<Usr> usrs = await sql.Queryable<Usr>().Where(it => it.account == account && it.password == tmp).ToListAsync();
                    Console.WriteLine($"{usrs.Count}");
                    if (usrs.Count > 0)
                    {
                        return Ok(new CustomResponse { ok = "no", message = "please try another account or password" });
                    }
                    else
                    {
                        long num = sql.Queryable<Usr>().Max(it => it.user_id) + 1;
                        var usr = new Usr
                        {
                            user_id = num,
                            account = account,
                            password = gethash(password),
                        };
                        var count = await sql.Insertable(usr).ExecuteCommandAsync();
                        if(count == 1)
                        {
                            return Ok(new CustomResponse { ok = "yes",value = num, message = "success!" });
                        }
                        else
                        {
                            return Ok(new CustomResponse { ok = "no", message = "Unknown Exception, please try it again" });
                        }
                    }
                }
                catch(Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    return BadRequest();
                }
            }
            else
            {
                Console.WriteLine("连接失败");
                return BadRequest();
            }
        }
    }
}

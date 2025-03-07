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
using System.Linq;

namespace Backend.Controllers
{
    [ApiController]
    [Route("api/resource")]
    public class SynchronizeController : Controller
    {
        public class podo
        {
            public string Configure_id { get; set; }
            public int totalTime { get; set; }
            public int breakTime { get; set; }
            public int cycleTimes { get; set; }
            public string task { get; set; }
        }
        public class pullRequest
        {
            public long user_id { get; set; }
        }
        public class pushRequest
        {
            public long user_id { get; set; }
            public List<podo> podos { get; set; }
        }
        [HttpPost("pullFromCloud")]
        public async Task<IActionResult> pullFromCloud([FromBody] pullRequest json)
        {
            var id = json.user_id;
            Console.WriteLine(id);
            DatabaseConnection db = new DatabaseConnection();
            if(db.Conn() == true)
            {
                try
                {
                    SqlSugarClient sql = db.sqlORM;
                    {
                        List<podo> ret = await sql.Queryable<Configure>()
                            .Where(it => it.user_id == id)
                            .Select(it => new podo
                            {
                                Configure_id = it.Configure_id,
                                totalTime = it.totalTime,
                                breakTime = it.breakTime,
                                cycleTimes = it.cycleTimes,
                                task = it.task
                            }
                            )
                            .ToListAsync();
                        return Ok(new CustomResponse { ok = "yes", value = ret, message = "成功" });
                    }
                }
                catch(Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    return BadRequest(ex.Message);
                }
            }
            else
            {
                Console.WriteLine("数据库连接失败");
                return BadRequest("连接失败");
            }
        }
        [HttpPost("pushToCloud")]
        public async Task<IActionResult> pushToCloud([FromBody] pushRequest json)
        {
            var id = json.user_id;
            var podos = json.podos;
            if(podos == null || podos.Count == 0)
            {
                return Ok(new CustomResponse { ok = "yes", message = "同步内容为空" });
            }
            Console.WriteLine(id);
            DatabaseConnection db = new DatabaseConnection();
            if (db.Conn() == true)
            {
                try
                {
                    SqlSugarClient sql = db.sqlORM;
                    {
                        List<podo> getter = await sql.Queryable<Configure>()
                            .Where(it => it.user_id == id)
                            .Select(it => new podo
                            {
                                Configure_id = it.Configure_id,
                                totalTime = it.totalTime,
                                breakTime = it.breakTime,
                                cycleTimes = it.cycleTimes,
                                task = it.task
                            }
                            )
                            .ToListAsync();
                        List<podo> tmp = podos.Except(getter).ToList();
                      
                        List<Configure> poster = new List<Configure>();
                        foreach(var i in tmp)
                        {
                            var config = new Configure
                            {
                                Configure_id = i.Configure_id,
                                totalTime = i.totalTime,
                                breakTime = i.breakTime,
                                cycleTimes = i.cycleTimes,
                                task = i.task,
                                user_id = id
                            };
                            poster.Add(config);
                        }
                        Console.WriteLine(poster.Count);
                        try
                        {
                            var num = await sql.Insertable(poster).ExecuteCommandAsync();
                            return Ok(new CustomResponse { ok = "yes", value = num, message = "成功" });
                        }
                        catch (Exception ex)
                        {
                            return Ok(new CustomResponse { ok = "no", message = ex.Message });
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    return BadRequest(ex.Message);
                }
            }
            else
            {
                Console.WriteLine("数据库连接失败");
                return BadRequest("连接失败");
            }
        }
    }
}

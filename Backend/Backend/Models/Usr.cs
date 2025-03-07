using Oracle.ManagedDataAccess.Types;
using SqlSugar;

namespace Backend.Models
{
    public class Usr
    {
        //[SugarColumn(IsPrimaryKey = true)]
        public long user_id { get; set; }
        public string account { get; set; }
        public string password { get; set; }
    }
}

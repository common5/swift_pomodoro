using Oracle.ManagedDataAccess.Types;
using SqlSugar;

namespace Backend.Models
{
    public class Configure
    {
        public string Configure_id { get; set; }
        public int totalTime { get; set; }
        public int breakTime { get; set; }
        public int cycleTimes { get; set; }
        public long user_id { get; set; }
        public string task { get; set; }
    }
}

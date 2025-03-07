namespace Backend.Models
{
    public class CustomResponse
    {
        public string ok { get; set; }
        public object? value { get; set; }
        public string? message {  get; set; }
    }
}

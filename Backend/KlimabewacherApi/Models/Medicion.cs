using System;
namespace KlimabewacherApi.Properties
{
    public class Medicion
    {
        public int Id { get; set; }
        public string DeviceId { get; set; } = string.Empty;
        public double Temperatura { get; set; }
        public double Humedad { get; set; }
        public string? Ubicacion { get; set; }
        public DateTime FechaHora { get; set; } = DateTime.Now;
    }
}


using System;
namespace KlimabewacherApi.Properties
{
    public class Medicion
    {
        public int Id { get; set; }
        public string DeviceId { get; set; } = string.Empty;
        public float Temperatura { get; set; }
        public float Humedad { get; set; }
        public string? Ubicacion { get; set; }
        public DateTime FechaHora { get; set; } = DateTime.Now;
    }
}


using System;
using System.Security.Cryptography;
using System.Text;
using KlimabewacherApi.Context;
using KlimabewacherApi.Properties;
using KlimabewacherApi.Security;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace KlimabewacherApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class MedicionesController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IOptions<SecuritySettings> _settings;

        public MedicionesController(AppDbContext context, IOptions<SecuritySettings> settings)
        {
            _context = context;
            _settings = settings;
        }

        [HttpPost]
        public async Task<IActionResult> PostMedicion([FromBody] Medicion medicion, [FromHeader(Name = "X-Signature")] string? firma)
        {
            if (string.IsNullOrEmpty(firma))
                return Unauthorized("Falta la firma");

            var payload = $"{medicion.DeviceId}|{medicion.Temperatura}|{medicion.Humedad}|{medicion.Ubicacion}";
            var firmaEsperada = GenerarFirmaHmac(payload, _settings.Value.HmacSecret);

            if (firma != firmaEsperada.ToLower())
                return Unauthorized("Firma inválida");

            _context.Mediciones.Add(medicion);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Medición registrada exitosamente" });
        }

        private string GenerarFirmaHmac(string mensaje, string clave)
        {
            var keyBytes = Encoding.UTF8.GetBytes(clave);
            var messageBytes = Encoding.UTF8.GetBytes(mensaje);

            using var hmac = new HMACSHA256(keyBytes);
            var hash = hmac.ComputeHash(messageBytes);
            return Convert.ToHexString(hash); // Disponible en .NET 6+
        }
    }
}


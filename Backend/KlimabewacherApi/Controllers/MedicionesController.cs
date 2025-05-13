using System;
using System.Security.Cryptography;
using System.Text;
using KlimabewacherApi.Context;
using KlimabewacherApi.Properties;
using KlimabewacherApi.Security;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
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
        public async Task<IActionResult> PostMedicion([FromBody] Medicion medicion)
        {
            if (!Request.Headers.ContainsKey("Authorization"))
                return Unauthorized("Falta el encabezado de autorización");

            var authHeader = Request.Headers["Authorization"].ToString();
            if (!authHeader.StartsWith("Basic "))
                return Unauthorized("Encabezado de autorización inválido");

            var encodedCredentials = authHeader.Substring("Basic ".Length).Trim();
            var credentialBytes = Convert.FromBase64String(encodedCredentials);
            var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':');

            if (credentials.Length != 2)
                return Unauthorized("Credenciales mal formateadas");

            var username = credentials[0];
            var password = credentials[1];

            // Validar las credenciales (reemplaza con tu lógica de validación)
            if (username != "juanarias" || password != "Arias2020*")
                return Unauthorized("Credenciales inválidas");

            // Procesar la medición
            _context.Mediciones.Add(medicion);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Medición registrada exitosamente" });
        }

        [HttpGet("historial")]
        public async Task<IActionResult> GetHistorial()
        {
            var hoy = DateTime.Now.Date;

            var historial = await _context.Mediciones
                .Where(m => m.FechaHora.Date == hoy)
                .ToListAsync();


            return Ok(historial);
        }


    }
}


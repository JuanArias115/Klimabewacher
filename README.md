# 📡 Proyecto de Monitoreo Meteorológico IoT

Backend en **.NET 8** + **SQL Server** y Frontend en **Angular 19** para la recolección, almacenamiento y visualización de datos meteorológicos enviados por dispositivos IoT (ESP8266).

---

## 📋 Tecnologías usadas

- **Backend**: .NET 8 Web API
- **Base de datos**: SQL Server
- **Frontend**: Angular 19
- **ORM**: Entity Framework Core
- **Seguridad**: HMAC SHA256 para validación de autenticidad de peticiones

---

## 🚀 Instalación y configuración

### 🔧 Requisitos previos

- .NET 8 SDK
- Node.js + Angular CLI 19
- SQL Server
- Visual Studio, VS Code o tu editor favorito
- Postman (opcional, para pruebas API)

---

### 🛠️ Configuración del Backend (.NET 8)

1. Clona el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/tu-repo.git
   cd tu-repo/backend
   ```

2. Configura la cadena de conexión en `appsettings.json`:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=localhost;Database=NombreBD;User Id=usuario;Password=contraseña;"
   },
   "Security": {
     "HmacSecret": "claveSuperSecreta123"
   }
   ```

3. Instala dependencias necesarias:
   ```bash
   dotnet restore
   ```

4. Ejecuta migraciones para crear la base de datos:
   ```bash
   dotnet ef database update
   ```

5. Levanta el proyecto:
   ```bash
   dotnet run
   ```

La API estará disponible en: `http://localhost:5059`

---

### 🛠️ Configuración del Frontend (Angular 19)

1. Ve a la carpeta del frontend:
   ```bash
   cd tu-repo/frontend
   ```

2. Instala dependencias:
   ```bash
   npm install
   ```

3. Corre el proyecto:
   ```bash
   ng serve --open
   ```

La aplicación abrirá en `http://localhost:4200`

---

## 🧪 Pruebas de la API (Opcional)

Puedes usar Postman para enviar datos de prueba:

- **URL**: `http://localhost:5059/api/mediciones`
- **Método**: POST
- **Headers**:
  - `Content-Type: application/json`
  - `X-Signature: [Firma HMAC generada]`
- **Body** (JSON):
  ```json
  {
    "deviceId": "ESP001",
    "temperatura": 24.5,
    "humedad": 60,
    "ubicacion": "Bogotá, Colombia"
  }
  ```

---

## ⚙️ Estructura del proyecto

```
/backend
  /Controllers
  /Context
  /Models
  /Properties
  appsettings.json
  Program.cs
/frontend
  /src
    /app
    /components
    /services
  angular.json
```

---

## 🛡️ Seguridad implementada

- Uso de **HMAC SHA256** para validar que los datos vienen de dispositivos autorizados.
- Protección básica contra inyección de datos y peticiones no autenticadas.

---

## 📈 Próximas mejoras

- Autenticación de usuarios para visualizar el dashboard.
- Alarmas o notificaciones en caso de valores fuera de rango.
- Integración de sensores adicionales (presión atmosférica, lluvia).

---

## 🤝 Contribuciones

¡Se aceptan pull requests! ✨ Si tienes ideas o mejoras, no dudes en contribuir.

# 📡 IoT Weather Monitoring Project

Backend built with **.NET 8** + **SQL Server** and Frontend with **Angular 19** for collecting, storing, and visualizing weather data sent by IoT devices (**ESP8266**).

---

## 📋 Technologies Used

- **Backend**: .NET 8 Web API
- **Database**: SQL Server
- **Frontend**: Angular 19
- **ORM**: Entity Framework Core
- **Security**: HMAC SHA256 for data authenticity validation
- **Device**: ESP8266 (Wi-Fi microcontroller)

---

## 🚀 Installation and Setup

### 🔧 Prerequisites

- .NET 8 SDK
- Node.js + Angular CLI 19
- SQL Server
- Visual Studio, VS Code, or your favorite editor
- Postman (optional, for API testing)
- ESP8266 configured to send data over HTTP

---

### 🛠️ Backend Setup (.NET 8)

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo/backend
   ```

2. Configure the connection string in `appsettings.json`:
   ```json
   "ConnectionStrings": {
     "DefaultConnection": "Server=localhost;Database=YourDatabaseName;User Id=your_user;Password=your_password;"
   },
   "Security": {
     "HmacSecret": "yourSuperSecretKey123"
   }
   ```

3. Install required dependencies:
   ```bash
   dotnet restore
   ```

4. Run database migrations:
   ```bash
   dotnet ef database update
   ```

5. Launch the project:
   ```bash
   dotnet run
   ```

The API will be available at: `http://localhost:5059`

---

### 🛠️ Frontend Setup (Angular 19)

1. Navigate to the frontend folder:
   ```bash
   cd your-repo/frontend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Serve the project:
   ```bash
   ng serve --open
   ```

The application will open at `http://localhost:4200`

---

## 🧪 API Testing (Optional)

Use Postman to send test data:

- **URL**: `http://localhost:5059/api/mediciones`
- **Method**: POST
- **Headers**:
  - `Content-Type: application/json`
  - `X-Signature: [Generated HMAC Signature]`
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

## ⚙️ Project Structure

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

## 🛡️ Security Implemented

- Use of **HMAC SHA256** to validate that data originates from authorized devices.
- Basic protection against data injection and unauthorized requests.

---

## 📈 Future Improvements

- User authentication for dashboard access
- Alarms or notifications for out-of-range values
- Integration of additional sensors (atmospheric pressure, rain)

---

## 🤝 Contributions

Pull requests are welcome! ✨ Feel free to suggest ideas or improvements.

---

This project uses an **ESP8266** to collect weather data and securely send it to the backend via HTTP with HMAC authentication.

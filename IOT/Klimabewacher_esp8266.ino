#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecure.h>
#include <DHT.h>
#include <base64.h>

#define DHTPIN D4
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

const char* ssid = "MagentaWLAN-JDTA";
const char* password = "19324181852170794121";

// Tu nueva API en HTTPS
const char* serverUrl = "https://juanariasdev.com/Klimabewacher/api/mediciones";

// Credenciales básicas
const char* username = "juanarias";
const char* userPassword = "Arias2020*";

void setup() {
  Serial.begin(115200);
  dht.begin();

  Serial.println("Conectando a WiFi...");
  WiFi.begin(ssid, password);
  Serial.println("Esperando que el sensor DHT se estabilice...");
  delay(5000);  // Esperar 2 segundos antes de hacer nada
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\n✅ WiFi conectado");
}

void loop() {
  float temperatura = dht.readTemperature();
  float humedad = dht.readHumidity();
  String ubicacion = "KÖLN, Deutschland";

  if (isnan(temperatura) || isnan(humedad)) {
    Serial.println("❌ Error leyendo DHT22");
    delay(10000);
    return;
  }

  String json = "{\"deviceId\":\"ESP001\",\"temperatura\":" + String(temperatura) +
                ",\"humedad\":" + String(humedad) + ",\"ubicacion\":\"" + ubicacion + "\"}";

  Serial.println("📦 JSON:");
  Serial.println(json);

  if (WiFi.status() == WL_CONNECTED) {
    WiFiClientSecure client;
    client.setInsecure();  // ⚠️ Ignora verificación de certificado (válido solo si usas HTTPS seguro)

    HTTPClient http;
    http.begin(client, serverUrl);  // ✅ HTTPS real
    http.addHeader("Content-Type", "application/json");

    String credentials = String(username) + ":" + String(userPassword);
    String encodedCredentials = base64::encode(credentials);
    http.addHeader("Authorization", "Basic " + encodedCredentials);

    Serial.println("🔐 Authorization: Basic " + encodedCredentials);

    int httpCode = http.POST(json);
    Serial.print("📡 Código HTTP: ");
    Serial.println(httpCode);

    if (httpCode > 0) {
      String response = http.getString();
      Serial.println("✅ Respuesta:");
      Serial.println(response);
    } else {
      Serial.print("❌ POST falló: ");
      Serial.println(http.errorToString(httpCode));
    }

    http.end();
  } else {
    Serial.println("❌ WiFi no conectado.");
  }

  delay(300000);
}

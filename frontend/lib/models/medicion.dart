// models/medicion.dart

class Medicion {
  final String deviceId;
  final double temperatura;
  final double humedad;
  final String ubicacion;
  final DateTime fecha;

  Medicion({
    required this.deviceId,
    required this.temperatura,
    required this.humedad,
    required this.ubicacion,
    required this.fecha,
  });

  factory Medicion.fromJson(Map<String, dynamic> json) {
    return Medicion(
      deviceId: json['deviceId'],
      temperatura: (json['temperatura'] as num).toDouble(),
      humedad: (json['humedad'] as num).toDouble(),
      ubicacion: json['ubicacion'],
      fecha: DateTime.tryParse(json['fechaHora'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'temperatura': temperatura,
      'humedad': humedad,
      'ubicacion': ubicacion,
      'fechaHora': fecha.toIso8601String(),
    };
  }
}

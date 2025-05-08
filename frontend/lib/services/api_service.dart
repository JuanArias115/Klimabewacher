// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medicion.dart';

class ApiService {
  static const String _baseUrl =
      'https://juanariasdev.com/Klimabewacher/api/mediciones/historial';

  static Future<List<Medicion>> fetchMediciones() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Medicion.fromJson(item)).toList();
      } else {
        throw Exception(
          'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<Medicion?> fetchLatestMedicion() async {
    try {
      final mediciones = await fetchMediciones();
      return mediciones.isNotEmpty ? mediciones.first : null;
    } catch (e) {
      return null;
    }
  }
}

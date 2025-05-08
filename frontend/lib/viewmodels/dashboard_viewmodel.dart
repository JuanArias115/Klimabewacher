// viewmodels/dashboard_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/medicion.dart';
import '../services/api_service.dart';

class DashboardViewModel extends ChangeNotifier {
  Medicion? _medicionActual;
  List<Medicion> _historial = [];
  bool _isLoading = false;

  Medicion? get medicionActual => _medicionActual;
  List<Medicion> get historial => _historial;
  bool get isLoading => _isLoading;

  Future<void> fetchLatestMedicion() async {
    _isLoading = true;
    notifyListeners();

    try {
      _medicionActual = await ApiService.fetchLatestMedicion();
      _historial = await ApiService.fetchMediciones();
    } catch (e) {
      debugPrint('Error al obtener la medición: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

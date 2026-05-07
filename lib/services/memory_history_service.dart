// lib/services/memory_history_service.dart
// HISTORIAL SEPARADO POR USUARIO

import '../models/measurement_record.dart';

class MemoryHistoryService {
  // Mapa: username -> lista de mediciones
  static final Map<String, List<MeasurementRecord>> _userRecords = {};

  // Usuario actualmente logueado
  static String? _currentUser;

  // Establecer usuario actual
  static void setCurrentUser(String username) {
    _currentUser = username;
    if (!_userRecords.containsKey(username)) {
      _userRecords[username] = [];
    }
  }

  // Limpiar datos del usuario actual (al cerrar sesión)
  static void clearCurrentUser() {
    _currentUser = null;
  }

  // Guardar una nueva medición para el usuario actual
  static void saveMeasurement(MeasurementRecord record) {
    if (_currentUser == null) return;
    if (!_userRecords.containsKey(_currentUser)) {
      _userRecords[_currentUser!] = [];
    }
    _userRecords[_currentUser!]!.add(record);
    _userRecords[_currentUser!]!.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Obtener todas las mediciones del usuario actual
  static List<MeasurementRecord> getMeasurements() {
    if (_currentUser == null) return [];
    return List.from(_userRecords[_currentUser] ?? []);
  }

  // Eliminar una medición específica del usuario actual
  static void deleteMeasurement(String id) {
    if (_currentUser == null) return;
    final records = _userRecords[_currentUser];
    if (records != null) {
      records.removeWhere((record) => record.id == id);
    }
  }

  // Eliminar todo el historial del usuario actual
  static void clearHistory() {
    if (_currentUser == null) return;
    _userRecords[_currentUser] = [];
  }
}

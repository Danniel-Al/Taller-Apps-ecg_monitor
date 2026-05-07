// lib/services/memory_history_service.dart


import '../models/measurement_record.dart';

class MemoryHistoryService {

  static final Map<String, List<MeasurementRecord>> _userRecords = {};


  static String? _currentUser;


  static void setCurrentUser(String username) {
    _currentUser = username;
    if (!_userRecords.containsKey(username)) {
      _userRecords[username] = [];
    }
  }


  static void clearCurrentUser() {
    _currentUser = null;
  }


  static void saveMeasurement(MeasurementRecord record) {
    final String? current = _currentUser;
    if (current == null) return;
    if (!_userRecords.containsKey(current)) {
      _userRecords[current] = [];
    }
    _userRecords[current]!.add(record);
    _userRecords[current]!.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }


  static List<MeasurementRecord> getMeasurements() {
    final String? current = _currentUser;
    if (current == null) return [];
    return List.from(_userRecords[current] ?? []);
  }


  static void deleteMeasurement(String id) {
    final String? current = _currentUser;
    if (current == null) return;
    _userRecords[current]?.removeWhere((record) => record.id == id);


  }


  static void clearHistory() {
    final String? current = _currentUser;
    if (current == null) return;
    _userRecords[current] = [];
  }
}
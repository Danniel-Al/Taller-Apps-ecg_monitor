// lib/services/history_service.dart
// SERVICIO PARA GUARDAR Y CARGAR EL HISTORIAL DE MEDICIONES

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/measurement_record.dart';

class HistoryService {
  static const String _historyKey = 'measurement_history';

  static Future<void> saveMeasurement(MeasurementRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? existing = prefs.getStringList(_historyKey);
    final List<String> updated = existing ?? [];
    updated.add(jsonEncode(record.toMap()));
    await prefs.setStringList(_historyKey, updated);
  }

  static Future<List<MeasurementRecord>> loadMeasurements() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(_historyKey);
    if (stored == null) return [];
    final records = stored.map((item) => MeasurementRecord.fromMap(jsonDecode(item))).toList();
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return records;
  }

  static Future<void> deleteMeasurement(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList(_historyKey);
    if (stored == null) return;
    final updated = stored.where((item) => jsonDecode(item)['id'] != id).toList();
    await prefs.setStringList(_historyKey, updated);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
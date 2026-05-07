// lib/services/memory_history_service.dart
// SERVICIO DE HISTORIAL EN MEMORIA (SE BORRA AL CERRAR LA APP)

import '../models/measurement_record.dart';

class MemoryHistoryService {
  // Lista estática que se mantiene mientras la app está abierta
  static final List<MeasurementRecord> _records = [];

  // Guardar una nueva medición
  static void saveMeasurement(MeasurementRecord record) {
    _records.add(record);
    // Ordenar por fecha descendente (más reciente primero)
    _records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // Obtener todas las mediciones
  static List<MeasurementRecord> getMeasurements() {
    return List.from(_records);
  }

  // Eliminar una medición específica
  static void deleteMeasurement(String id) {
    _records.removeWhere((record) => record.id == id);
  }

  // Eliminar todo el historial
  static void clearHistory() {
    _records.clear();
  }

  // Obtener cantidad de mediciones
  static int getCount() {
    return _records.length;
  }
}


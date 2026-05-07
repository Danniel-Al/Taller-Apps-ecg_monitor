// Agregar al inicio
import '../services/memory_history_service.dart';
import '../models/measurement_record.dart';

// Agregar esta función dentro de la clase ResultScreen
void _saveMeasurement(String recommendation, ComparisonResult comparison) {
  final record = MeasurementRecord(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    dateTime: DateTime.now(),
    heartRate: heartRate,
    ageRange: ageRange,
    gender: gender,
    conditions: conditions,
    symptoms: symptoms,
    medications: medications,
    recommendation: recommendation,
    comparisonStatus: comparison.status,
    comparisonText: '${comparison.status} - ${comparison.percentile}',
  );
  MemoryHistoryService.saveMeasurement(record);
}


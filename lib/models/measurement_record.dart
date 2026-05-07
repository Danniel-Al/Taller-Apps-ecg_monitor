// lib/models/measurement_record.dart
// MODELO DE DATOS PARA GUARDAR CADA MEDICIÓN

class MeasurementRecord {
  final String id;
  final DateTime dateTime;
  final int heartRate;
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;
  final String recommendation;
  final String comparisonStatus;
  final String comparisonText;

  MeasurementRecord({
    required this.id,
    required this.dateTime,
    required this.heartRate,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
    required this.recommendation,
    required this.comparisonStatus,
    required this.comparisonText,
  });
}

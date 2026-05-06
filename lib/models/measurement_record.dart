// lib/models/measurement_record.dart
// MODELO DE DATOS PARA GUARDAR CADA MEDICIÓN REALIZADA

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'heartRate': heartRate,
      'ageRange': ageRange,
      'gender': gender,
      'conditions': conditions,
      'symptoms': symptoms,
      'medications': medications,
      'recommendation': recommendation,
      'comparisonStatus': comparisonStatus,
      'comparisonText': comparisonText,
    };
  }

  factory MeasurementRecord.fromMap(Map<String, dynamic> map) {
    return MeasurementRecord(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      heartRate: map['heartRate'],
      ageRange: map['ageRange'],
      gender: map['gender'],
      conditions: map['conditions'],
      symptoms: map['symptoms'],
      medications: map['medications'],
      recommendation: map['recommendation'],
      comparisonStatus: map['comparisonStatus'],
      comparisonText: map['comparisonText'],
    );
  }
}
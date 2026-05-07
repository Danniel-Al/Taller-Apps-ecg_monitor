// lib/models/measurement_record.dart
// CON NUEVO CAMPO correlationAnalysis

class MeasurementRecord {
  final String id;
  final DateTime dateTime;
  final int heartRate;
  final int ageRange;
  final int gender;
  final List<int> conditions;
  final int symptoms;
  final int medications;
  final String recommendation;
  final String comparisonStatus;
  final String comparisonText;
  final String correlationAnalysis;  // NUEVO CAMPO

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
    required this.correlationAnalysis,
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
      'correlationAnalysis': correlationAnalysis,
    };
  }

  factory MeasurementRecord.fromMap(Map<String, dynamic> map) {
    return MeasurementRecord(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      heartRate: map['heartRate'],
      ageRange: map['ageRange'],
      gender: map['gender'],
      conditions: List<int>.from(map['conditions'] ?? []),
      symptoms: map['symptoms'],
      medications: map['medications'],
      recommendation: map['recommendation'],
      comparisonStatus: map['comparisonStatus'],
      comparisonText: map['comparisonText'],
      correlationAnalysis: map['correlationAnalysis'] ?? '',
    );
  }
}

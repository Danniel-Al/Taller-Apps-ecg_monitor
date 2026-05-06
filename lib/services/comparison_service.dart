// lib/services/comparison_service.dart
// SERVICIO PARA COMPARAR FRECUENCIA CARDÍACA CON RANGOS NORMALES

class ComparisonService {
  static const Map<String, Map<String, int>> _normalRanges = {
    '18-30': {'min': 60, 'max': 100},
    '31-45': {'min': 60, 'max': 100},
    '46-60': {'min': 60, 'max': 100},
    '61-75': {'min': 60, 'max': 95},
    '75+': {'min': 60, 'max': 90},
  };

  static ComparisonResult compare({
    required int heartRate,
    required int ageRange,
    required int gender,
  }) {
    String ageGroup = _getAgeGroup(ageRange);
    String genderText = _getGenderText(gender);
    int minNormal = _normalRanges[ageGroup]!['min']!;
    int maxNormal = _normalRanges[ageGroup]!['max']!;
    String status = _getStatus(heartRate, minNormal, maxNormal);
    String statusColor = _getStatusColor(status);
    return ComparisonResult(
      heartRate: heartRate,
      minNormal: minNormal,
      maxNormal: maxNormal,
      ageGroup: ageGroup,
      gender: genderText,
      status: status,
      statusColor: statusColor,
      percentile: _getPercentile(heartRate, minNormal, maxNormal),
    );
  }

  static String _getAgeGroup(int ageRange) => const ['18-30', '31-45', '46-60', '61-75', '75+'][ageRange];
  static String _getGenderText(int gender) => const ['Femenino', 'Masculino', 'Prefiero no decirlo'][gender];
  static String _getStatus(int hr, int min, int max) => hr < min ? 'Por debajo de lo normal' : (hr > max ? 'Por encima de lo normal' : 'Normal');
  static String _getStatusColor(String status) => status == 'Normal' ? 'verde' : (status == 'Por debajo de lo normal' ? 'naranja' : 'rojo');
  static String _getPercentile(int hr, int min, int max) => hr < min ? '${min - hr} lpm por debajo del mínimo' : (hr > max ? '${hr - max} lpm por encima del máximo' : (hr <= (min + max) ~/ 2 ? 'En el rango normal bajo' : 'En el rango normal alto'));
}

class ComparisonResult {
  final int heartRate;
  final int minNormal;
  final int maxNormal;
  final String ageGroup;
  final String gender;
  final String status;
  final String statusColor;
  final String percentile;
  ComparisonResult({required this.heartRate, required this.minNormal, required this.maxNormal, required this.ageGroup, required this.gender, required this.status, required this.statusColor, required this.percentile});
}
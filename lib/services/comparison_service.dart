// lib/services/comparison_service.dart
// SERVICIO PARA COMPARAR FRECUENCIA CARDÍACA CON RANGOS NORMALES POR EDAD

class ComparisonService {
  // Rangos normales de FC por edad
  static const Map<String, Map<String, int>> _normalRanges = {
    '18-30': {'min': 60, 'max': 100},
    '31-45': {'min': 60, 'max': 100},
    '46-60': {'min': 60, 'max': 100},
    '61-75': {'min': 60, 'max': 95},
    '75+': {'min': 60, 'max': 90},
  };
  
  // Obtener comparación completa
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
  
  static String _getAgeGroup(int ageRange) {
    const groups = ['18-30', '31-45', '46-60', '61-75', '75+'];
    return groups[ageRange];
  }
  
  static String _getGenderText(int gender) {
    const genders = ['Femenino', 'Masculino', 'Prefiero no decirlo'];
    return genders[gender];
  }
  
  static String _getStatus(int hr, int min, int max) {
    if (hr < min) return 'Por debajo de lo normal';
    if (hr > max) return 'Por encima de lo normal';
    return 'Normal';
  }
  
  static String _getStatusColor(String status) {
    if (status == 'Normal') return 'verde';
    if (status == 'Por debajo de lo normal') return 'naranja';
    return 'rojo';
  }
  
  static String _getPercentile(int hr, int min, int max) {
    if (hr < min) {
      int diff = min - hr;
      return '${diff} lpm por debajo del mínimo';
    } else if (hr > max) {
      int diff = hr - max;
      return '${diff} lpm por encima del máximo';
    } else {
      int center = (min + max) ~/ 2;
      if (hr <= center) {
        return 'En el rango normal bajo';
      } else {
        return 'En el rango normal alto';
      }
    }
  }
}

// Clase para almacenar el resultado de la comparación
class ComparisonResult {
  final int heartRate;
  final int minNormal;
  final int maxNormal;
  final String ageGroup;
  final String gender;
  final String status;
  final String statusColor;
  final String percentile;
  
  ComparisonResult({
    required this.heartRate,
    required this.minNormal,
    required this.maxNormal,
    required this.ageGroup,
    required this.gender,
    required this.status,
    required this.statusColor,
    required this.percentile,
  });
}

<s
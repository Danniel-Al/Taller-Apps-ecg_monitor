// lib/services/comparison_service.dart


class ComparisonService {
  static const Map<String, Map<String, dynamic>> _detailedRanges = {
    '18-30': {'min': 60, 'max': 100, 'ideal_min': 65, 'ideal_max': 85, 'description': 'adultos jóvenes activos'},
    '31-45': {'min': 60, 'max': 100, 'ideal_min': 65, 'ideal_max': 85, 'description': 'adultos en plena productividad'},
    '46-60': {'min': 60, 'max': 100, 'ideal_min': 65, 'ideal_max': 85, 'description': 'adultos de mediana edad'},
    '61-75': {'min': 60, 'max': 95, 'ideal_min': 62, 'ideal_max': 82, 'description': 'adultos mayores activos'},
    '75+': {'min': 60, 'max': 90, 'ideal_min': 60, 'ideal_max': 80, 'description': 'adultos mayores avanzados'},
  };

  static DetailedComparison getDetailedComparison({
    required int heartRate,
    required int ageRange,
    required int gender,
    required List<int> conditions,
    required int symptoms,
  }) {
    String ageGroup = _getAgeGroup(ageRange);
    String genderText = _getGenderText(gender);
    var range = _detailedRanges[ageGroup]!;

    int minNormal = range['min'];
    int maxNormal = range['max'];
    int idealMin = range['ideal_min'];
    int idealMax = range['ideal_max'];
    String description = range['description'];

    String status = _getStatus(heartRate, minNormal, maxNormal);
    String statusColor = _getStatusColor(status);
    String percentile = _getPercentile(heartRate, minNormal, maxNormal);

    String recommendation = _buildDetailedRecommendation(
      heartRate, status, minNormal, maxNormal, idealMin, idealMax, 
      ageGroup, genderText, description, conditions, symptoms
    );

    return DetailedComparison(
      heartRate: heartRate,
      minNormal: minNormal,
      maxNormal: maxNormal,
      idealMin: idealMin,
      idealMax: idealMax,
      ageGroup: ageGroup,
      gender: genderText,
      status: status,
      statusColor: statusColor,
      percentile: percentile,
      recommendation: recommendation,
      description: description,
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
      if (diff <= 5) return 'Ligeramente por debajo ($diff lpm)';
      if (diff <= 10) return 'Moderadamente por debajo ($diff lpm)';
      return 'Significativamente por debajo ($diff lpm)';
    } else if (hr > max) {
      int diff = hr - max;
      if (diff <= 5) return 'Ligeramente por encima ($diff lpm)';
      if (diff <= 10) return 'Moderadamente por encima ($diff lpm)';
      return 'Significativamente por encima ($diff lpm)';
    } else {
      int center = (min + max) ~/ 2;
      if (hr <= center) return 'En el rango normal bajo';
      return 'En el rango normal alto';
    }
  }

  static String _buildDetailedRecommendation(
    int hr, String status, int min, int max, int idealMin, int idealMax,
    String ageGroup, String gender, String description, List<int> conditions, int symptoms
  ) {
    String rec = '';

    if (status == 'Normal') {
      rec = "✅ **¡Tu ritmo cardíaco es normal!**\n\n"
          "Para $description de tu grupo etario ($ageGroup años), lo esperado es un rango de $min-$max lpm. "
          "Tu medición de $hr lpm está dentro de los parámetros saludables.\n\n"
          "El rango ideal para tu edad es de $idealMin-$idealMax lpm. "
          "Tu corazón está funcionando dentro de lo esperado.\n\n";

      if (hr > idealMax) {
        rec += "💛 **Nota**: Aunque estás dentro del rango normal, tu ritmo está en la parte alta. "
              "Si no hiciste ejercicio antes de medirte, podrías beneficiarte de técnicas de relajación.\n\n";
      } else if (hr < idealMin) {
        rec += "💚 **Nota**: Tu ritmo está en la parte baja del rango normal. "
              "Esto puede ser señal de buena condición cardiovascular, especialmente si eres activo físicamente.\n\n";
      }
    } else if (status == 'Por debajo de lo normal') {
      rec = "🧡 **Tu ritmo cardíaco está por debajo de lo esperado (Bradicardia)**\n\n"
          "Para tu grupo etario ($ageGroup años), el rango normal es de $min-$max lpm. "
          "Tu medición de $hr lpm está por debajo de ese límite.\n\n"
          "**Esto puede significar:**\n"
          "• **Bueno**: Si eres deportista, puede ser una señal de excelente condición física.\n"
          "• **Precaución**: Si no haces ejercicio, podría indicar que tu corazón bombea con menos fuerza.\n\n"
          "**Síntomas a vigilar:** Fatiga, mareos, desmayos, confusión o dificultad para hacer ejercicio.\n\n";
    } else {
      rec = "❤️‍🔥 **Tu ritmo cardíaco está por encima de lo esperado (Taquicardia)**\n\n"
          "Para tu grupo etario ($ageGroup años), el rango normal es de $min-$max lpm. "
          "Tu medición de $hr lpm supera este límite.\n\n"
          "**Causas frecuentes temporales:** Estrés, ansiedad, cafeína, deshidratación, fiebre o ejercicio reciente.\n\n"
          "**Síntomas a vigilar:** Palpitaciones, dolor en el pecho, falta de aire, mareos o desmayos.\n\n";
    }

    if (conditions.isNotEmpty) {

      rec += "⚠️ **Considera tu historial médico**: Tienes antecedentes cardíacos reportados. "
            "Comparte estas mediciones con tu médico tratante.\n\n";
    }

    if (symptoms > 0) {
      rec += "🤒 **Coincidencia con síntomas**: Has reportado síntomas recientes. "
            "Si los síntomas persisten junto con este valor, agenda una consulta.\n\n";
    }

    rec += "---\n📌 **Recuerda**: Una sola medición es una foto del momento. "
          "Lo importante es la tendencia en el tiempo. Realiza mediciones periódicas para conocer tu patrón normal.";

    return rec;
  }
}

class DetailedComparison {
  final int heartRate;
  final int minNormal;
  final int maxNormal;
  final int idealMin;
  final int idealMax;
  final String ageGroup;
  final String gender;
  final String status;
  final String statusColor;
  final String percentile;
  final String recommendation;
  final String description;

  DetailedComparison({
    required this.heartRate,
    required this.minNormal,
    required this.maxNormal,
    required this.idealMin,
    required this.idealMax,
    required this.ageGroup,
    required this.gender,
    required this.status,
    required this.statusColor,
    required this.percentile,
    required this.recommendation,
    required this.description,
  });
}

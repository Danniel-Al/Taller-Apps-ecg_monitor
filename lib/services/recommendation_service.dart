// lib/services/recommendation_service.dart
// SERVICIO PARA GENERAR RECOMENDACIONES

class RecommendationService {
  static String getRecommendation({
    required int heartRate,
    required int ageRange,
    required int gender,
    required int conditions,
    required int symptoms,
    required int medications,
  }) {
    String fcStatus = _getFCStatus(heartRate);
    String recommendation = _buildBaseRecommendation(heartRate, fcStatus);
    recommendation += _getConditionsWarning(conditions, symptoms, heartRate);
    recommendation += _getFinalSuggestion(fcStatus, conditions, symptoms);
    return recommendation;
  }

  static String _getFCStatus(int heartRate) {
    if (heartRate < 60) return 'baja';
    if (heartRate > 100) return 'alta';
    return 'normal';
  }

  static String _buildBaseRecommendation(int heartRate, String status) {
    switch (status) {
      case 'baja':
        return '• Tu frecuencia cardíaca es de $heartRate lpm, lo cual está por debajo del rango normal (60-100 lpm).\n\n';
      case 'alta':
        return '• Tu frecuencia cardíaca es de $heartRate lpm, lo cual está por encima del rango normal (60-100 lpm).\n\n';
      default:
        return '• Tu frecuencia cardíaca es de $heartRate lpm, dentro del rango normal (60-100 lpm).\n\n';
    }
  }

  static String _getConditionsWarning(int conditions, int symptoms, int heartRate) {
    String warning = '';
    if (conditions == 1) warning += '⚠️ Tienes hipertensión registrada. Mantén control periódico de tu presión arterial.\n\n';
    else if (conditions == 2) warning += '⚠️ Tienes insuficiencia cardíaca. Consulta a tu médico si este valor se repite.\n\n';
    else if (conditions == 3) warning += '⚠️ Antecedente de infarto. Es importante que realices controles cardiológicos regulares.\n\n';
    else if (conditions == 4) warning += '⚠️ Tienes arritmias diagnosticadas. Si sientes palpitaciones frecuentes, consulta a tu médico.\n\n';
    if (symptoms == 1 && heartRate > 90) warning += '💓 Reportaste palpitaciones. Con tu FC elevada, considera realizarte un electrocardiograma.\n\n';
    else if (symptoms == 2) warning += '❗ Reportaste dolor en el pecho. No lo ignores. Consulta a un médico lo antes posible.\n\n';
    else if (symptoms == 3 && heartRate < 60) warning += '😵 Reportaste mareos y tu FC es baja. Podrías tener bradicardia sintomática. Revisa con tu médico.\n\n';
    return warning.isEmpty ? '✅ No se detectaron factores de riesgo adicionales.\n\n' : warning;
  }

  static String _getFinalSuggestion(String fcStatus, int conditions, int symptoms) {
    if (fcStatus == 'normal' && conditions == 0 && symptoms == 0) {
      return '📌 Recomendación: Mantén tu estilo de vida saludable. Realiza mediciones periódicas cada 15 días.';
    } else if (fcStatus != 'normal') {
      return '📌 Recomendación: Toma mediciones durante 3 días consecutivos. Si se mantiene alterada, consulta a un médico.';
    } else {
      return '📌 Recomendación: Continúa con tu seguimiento habitual. Ante cualquier síntoma nuevo, consulta a tu médico.';
    }
  }
}
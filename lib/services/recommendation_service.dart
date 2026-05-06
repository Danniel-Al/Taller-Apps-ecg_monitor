// lib/services/recommendation_service.dart
// SERVICIO PARA GENERAR RECOMENDACIONES SEGÚN FRECUENCIA CARDÍACA Y DATOS DEMOGRÁFICOS

class RecommendationService {
  // Genera recomendación basada en FC y datos del usuario
  static String getRecommendation({
    required int heartRate,
    required int ageRange,
    required int gender,
    required int conditions,
    required int symptoms,
    required int medications,
  }) {
    // Determinar estado de la FC
    String fcStatus = _getFCStatus(heartRate);
    
    // Construir recomendación base
    String recommendation = _buildBaseRecommendation(heartRate, fcStatus);
    
    // Agregar advertencias según antecedentes
    recommendation += _getConditionsWarning(conditions, symptoms, heartRate);
    
    // Agregar sugerencia final
    recommendation += _getFinalSuggestion(fcStatus, conditions, symptoms);
    
    return recommendation;
  }
  
  // Determinar si la FC es normal, baja o alta
  static String _getFCStatus(int heartRate) {
    if (heartRate < 60) return 'baja';
    if (heartRate > 100) return 'alta';
    return 'normal';
  }
  
  // Recomendación base según el valor de FC
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
  
  // Advertencias según antecedentes y síntomas
  static String _getConditionsWarning(int conditions, int symptoms, int heartRate) {
    String warning = '';
    
    // Antecedentes cardíacos (condiciones)
    if (conditions == 1) { // Hipertensión
      warning += '⚠️ Tienes hipertensión registrada. Mantén control periódico de tu presión arterial.\n\n';
    } else if (conditions == 2) { // Insuficiencia cardíaca
      warning += '⚠️ Tienes insuficiencia cardíaca. Consulta a tu médico si este valor se repite.\n\n';
    } else if (conditions == 3) { // Infarto previo
      warning += '⚠️ Antecedente de infarto. Es importante que realices controles cardiológicos regulares.\n\n';
    } else if (conditions == 4) { // Arritmias
      warning += '⚠️ Tienes arritmias diagnosticadas. Si sientes palpitaciones frecuentes, consulta a tu médico.\n\n';
    }
    
    // Síntomas actuales
    if (symptoms == 1 && heartRate > 90) { // Palpitaciones + FC elevada
      warning += '💓 Reportaste palpitaciones. Con tu FC elevada, considera realizarte un electrocardiograma.\n\n';
    } else if (symptoms == 2) { // Dolor en el pecho
      warning += '❗ Reportaste dolor en el pecho. No lo ignores. Consulta a un médico lo antes posible.\n\n';
    } else if (symptoms == 3 && heartRate < 60) { // Mareos + FC baja
      warning += '😵 Reportaste mareos y tu FC es baja. Podrías tener bradicardia sintomática. Revisa con tu médico.\n\n';
    }
    
    return warning.isEmpty ? '✅ No se detectaron factores de riesgo adicionales.\n\n' : warning;
  }
  
  // Sugerencia final según el estado general
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

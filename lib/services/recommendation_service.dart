// lib/services/recommendation_service.dart


class RecommendationService {
  static String getDetailedRecommendation({
    required int heartRate,
    required int ageRange,
    required int gender,
    required List<int> conditions,
    required int symptoms,
    required int medications,
  }) {
    String status = _getStatus(heartRate);
    String ageGroup = _getAgeGroup(ageRange);
    String genderText = _getGenderText(gender);

    String recommendation = '';

    recommendation += _getPersonalizedOpening(heartRate, status, ageGroup, genderText);
    recommendation += _getDetailedAnalysis(heartRate, status, ageRange);
    recommendation += _getRiskFactors(conditions, symptoms, heartRate);
    recommendation += _getMedicationConsideration(medications, heartRate);
    recommendation += _getPracticalAdvice(heartRate, status, conditions, symptoms);
    recommendation += _getWhenToSeeDoctor(heartRate, status, conditions, symptoms);
    recommendation += _getTipsToImprove(heartRate, status);

    return recommendation;
  }

  static String _getStatus(int heartRate) {
    if (heartRate < 60) return 'bradicardia';
    if (heartRate > 100) return 'taquicardia';
    return 'normal';
  }

  static String _getAgeGroup(int ageRange) {
    const groups = ['joven adulto (18-30 años)', 'adulto (31-45 años)', 'adulto maduro (46-60 años)', 'adulto mayor (61-75 años)', 'adulto mayor avanzado (>75 años)'];
    return groups[ageRange];
  }

  static String _getGenderText(int gender) {
    const genders = ['mujer', 'hombre', 'persona'];
    return genders[gender];
  }

  static String _getPersonalizedOpening(int hr, String status, String ageGroup, String gender) {
    return "📊 **ANÁLISIS PERSONALIZADO**\n\n"
        "Hola, como $gender en el rango de edad $ageGroup, tu frecuencia cardíaca actual es de $hr latidos por minuto (lpm).\n\n"
        "Basado en tu perfil fisiológico y los datos que compartiste, a continuación encontrarás un análisis detallado:\n\n";
  }

  static String _getDetailedAnalysis(int hr, String status, int ageRange) {
    int normalMax = ageRange >= 3 ? 95 : 100;

    if (status == 'normal') {
      return "**💚 TU RITMO ES NORMAL**\n\n"
          "Tu frecuencia cardíaca se encuentra dentro del rango saludable que es de 60-${normalMax} lpm para tu edad. "
          "Esto indica que tu corazón está funcionando de manera eficiente en reposo.\n\n";


    } else if (status == 'bradicardia') {
      return "**🧡 RITMO LENTO (BRADICARDIA)**\n\n"
          "Tu frecuencia cardíaca está por debajo de 60 lpm. Esto se conoce como bradicardia.\n\n"
          "**¿Es preocupante?** Depende:\n"
          "• Si eres deportista o tienes buena condición física, puede ser normal y hasta saludable.\n"
          "• Si no haces ejercicio regularmente, podría indicar que tu corazón no está bombeando con la fuerza adecuada.\n"
          "• La bradicardia puede causar mareos, fatiga o desmayos si es muy marcada.\n\n";
    } else {
      return "**❤️‍🔥 RITMO RÁPIDO (TAQUICARDIA)**\n\n"
          "Tu frecuencia cardíaca supera los ${normalMax} lpm, lo que se considera taquicardia.\n\n"
          "**Posibles causas temporales:**\n"
          "• Estrés o ansiedad\n"
          "• Cafeína o bebidas energéticas\n"
          "• Deshidratación\n"
          "• Fiebre o infección\n"
          "• Ejercicio reciente\n\n"
          "Si persiste en reposo, puede requerir atención médica.\n\n";
    }
  }

  static String _getRiskFactors(List<int> conditions, int symptoms, int hr) {
    String risk = "**⚠️ FACTORES DE RIESGO CONSIDERADOS**\n\n";
    bool hasRisk = false;

    if (conditions.contains(0)) {
      risk += "• **Hipertensión arterial**: Tienes antecedentes de presión alta.\n\n";

      hasRisk = true;
    }
    if (conditions.contains(1)) {
      risk += "• **Diabetes mellitus**: La diabetes puede dañar los nervios que controlan el corazón.\n\n";
      hasRisk = true;
    }
    if (conditions.contains(2)) {
      risk += "• **Colesterol alto**: Aumenta el riesgo de aterosclerosis.\n\n";
      hasRisk = true;
    }
    if (conditions.contains(3)) {
      risk += "• **Insuficiencia cardíaca**: Requiere seguimiento médico estrecho.\n\n";
      hasRisk = true;
    }
    if (conditions.contains(4)) {
      risk += "• **Infarto previo**: Requiere cuidados especiales.\n\n";
      hasRisk = true;
    }
    if (conditions.contains(5)) {
      risk += "• **Arritmias diagnosticadas**: Esta medición es importante para ti.\n\n";
      hasRisk = true;
    }
    if (conditions.contains(6)) {
      risk += "• **Cardiopatía congénita**: Requiere seguimiento cardiológico.\n\n";
      hasRisk = true;
    }
    if (conditions.contains(7)) {
      risk += "• **Tabaquismo**: El cigarrillo aumenta la FC y daña las arterias.\n\n";
      hasRisk = true;
    }

    if (symptoms == 1 && hr > 90) {
      risk += "• **Palpitaciones activas**: Reportaste palpitaciones y tu FC está elevada.\n\n";

      hasRisk = true;
    } else if (symptoms == 2) {
      risk += "• **Dolor en el pecho**: Síntoma de alerta. Requiere evaluación médica.\n\n";

      hasRisk = true;
    } else if (symptoms == 3 && hr < 60) {
      risk += "• **Mareos con ritmo lento**: Combinación que sugiere evaluación médica.\n\n";

      hasRisk = true;
    }

    if (!hasRisk) {
      risk += "✅ No se detectaron factores de riesgo adicionales.\n\n";

    }

    return risk;
  }

  static String _getMedicationConsideration(int medications, int hr) {
    if (medications == 0) return '';

    if (medications == 1) {
      return "**💊 CONSIDERACIÓN DE MEDICAMENTOS**\n\nEstás tomando betabloqueadores, que reducen la frecuencia cardíaca.\n\n";
    } else if (medications == 2) {
      return "**💊 CONSIDERACIÓN DE MEDICAMENTOS**\n\nLos antidepresivos pueden afectar el ritmo cardíaco.\n\n";
    } else if (medications == 3) {
      return "**💊 CONSIDERACIÓN DE MEDICAMENTOS**\n\nLos antiarrítmicos controlan tu ritmo. Comparte esta medición con tu cardiólogo.\n\n";
    } else if (medications == 4) {
      return "**💊 CONSIDERACIÓN DE MEDICAMENTOS**\n\nLos diuréticos pueden afectar tus electrolitos e influir en el ritmo cardíaco.\n\n";













    }
    return '';

  }

  static String _getPracticalAdvice(int hr, String status, List<int> conditions, int symptoms) {
    if (status == 'normal' && conditions.isEmpty && symptoms == 0) {
      return "**📋 RECOMENDACIONES PRÁCTICAS**\n\n"
          "1. Mantén tu estilo de vida saludable\n"
          "2. Realiza mediciones cada 15-30 días\n"
          "3. Hidrátate bien\n"
          "4. Duerme 7-8 horas\n\n";

    } else if (status != 'normal') {
      return "**📋 RECOMENDACIONES PRÁCTICAS**\n\n"
          "1. Toma 3 mediciones en días distintos\n"
          "2. Evita estimulantes (cafeína, alcohol)\n"
          "3. Practica respiración profunda\n"
          "4. Mantén un registro de síntomas\n\n";
    } else {
      return "**📋 RECOMENDACIONES PRÁCTICAS**\n\n"
          "1. Mantén controles médicos periódicos\n"
          "2. Realiza ejercicio moderado\n"
          "3. Sigue una dieta cardiosaludable\n\n";
    }


  }

  static String _getWhenToSeeDoctor(int hr, String status, List<int> conditions, int symptoms) {
    if (status == 'normal' && conditions.isEmpty && symptoms == 0) {
      return "**🏥 CUÁNDO CONSULTAR AL MÉDICO**\n\nNo hay urgencia médica. Continúa con tus controles de rutina.\n\n";


    } else {
      String medical = "**🏥 CUÁNDO CONSULTAR AL MÉDICO**\n\n";
      medical += "Consulta a un médico si presentas:\n\n";

      if (status == 'bradicardia') {
        medical += "• Mareos o desmayos\n• Fatiga extrema\n• Confusión\n";


      } else if (status == 'taquicardia') {
        medical += "• Palpitaciones prolongadas\n• Dolor en el pecho\n• Falta de aire\n• Sensación de desmayo\n";



      }

      if (symptoms == 2) {
        medical += "• **Dolor en el pecho** - Siempre requiere evaluación médica\n";
      }
      medical += "\n";
      return medical;
    }


  }

  static String _getTipsToImprove(int hr, String status) {
    return "**💪 CONSEJOS PARA MEJORAR TU SALUD**\n\n"
        "• Actividad física regular (150 min/semana)\n"
        "• Dieta mediterránea rica en omega-3\n"
        "• Controla el estrés con meditación o yoga\n"
        "• Evita tabaco y alcohol\n"
        "• Mantén un peso saludable\n"
        "• Duerme al menos 7 horas\n\n"
        "---\n💙 **Recuerda**: Esta app es una herramienta de monitoreo, no reemplaza la opinión de un profesional de la salud.";



  }
}
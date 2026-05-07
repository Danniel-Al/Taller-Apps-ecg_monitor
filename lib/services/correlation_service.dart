// lib/services/correlation_service.dart
class CorrelationService {
  static String getCorrelationAnalysis({
    required int heartRate,
    required int ageRange,
    required int gender,
    required List<int> conditions,
    required int symptoms,
  }) {
    String analysis = '';
    analysis += _getAgeCorrelation(heartRate, ageRange);
    analysis += _getGenderCorrelation(heartRate, gender);
    analysis += _getConditionsCorrelation(heartRate, conditions);
    analysis += _getSymptomsCorrelation(heartRate, symptoms);
    return analysis;
  }
  
  static String _getAgeCorrelation(int hr, int ageRange) {
    String ageGroup;
    int expectedMax = 100;
    
    switch (ageRange) {
      case 0: ageGroup = "18-30 años"; expectedMax = 100; break;
      case 1: ageGroup = "31-45 años"; expectedMax = 100; break;
      case 2: ageGroup = "46-60 años"; expectedMax = 100; break;
      case 3: ageGroup = "61-75 años"; expectedMax = 95; break;
      case 4: ageGroup = ">75 años"; expectedMax = 90; break;
      default: ageGroup = "desconocido";
    }
    
    if (hr > expectedMax) {
      return "• **Edad ($ageGroup)**: Tu FC está por encima del máximo esperado ($expectedMax lpm). La edad avanzada suele asociarse con menor FC máxima, pero tu ritmo elevado podría indicar esfuerzo, estrés o patología.\n\n";
    } else if (hr < 60 && ageRange < 3) {
      return "• **Edad ($ageGroup)**: Tu FC está por debajo de 60 lpm. En personas jóvenes, esto puede ser normal si eres deportista, pero si tienes síntomas como mareos, consulta.\n\n";
    } else if (hr < 55 && ageRange >= 3) {
      return "• **Edad ($ageGroup)**: Tu FC es baja ($hr lpm). En adultos mayores, la bradicardia puede estar relacionada con medicamentos o trastornos de conducción cardíaca.\n\n";
    }
    return "• **Edad ($ageGroup)**: Tu FC está dentro del rango esperado para tu grupo etario.\n\n";
  }
  
  static String _getGenderCorrelation(int hr, int gender) {
    String genderText = gender == 0 ? "Femenino" : (gender == 1 ? "Masculino" : "No especificado");
    if (gender == 0 && hr > 100) {
      return "• **Género ($genderText)**: Las mujeres pueden tener FC más alta en situaciones de ansiedad o estrés. Tu FC elevada podría estar relacionada con factores hormonales o emocionales.\n\n";
    } else if (gender == 1 && hr < 55) {
      return "• **Género ($genderText)**: En hombres activos físicamente, una FC baja puede ser signo de buena condición cardiovascular. Si no es tu caso, podría ser bradicardia.\n\n";
    }
    return "• **Género ($genderText)**: Tu FC es consistente con lo esperado.\n\n";
  }
  
  static String _getConditionsCorrelation(int hr, List<int> conditions) {
    if (conditions.isEmpty) {
      return "• **Antecedentes**: No reportaste factores de riesgo cardiovascular. ¡Sigue así!\n\n";
    }
    
    String text = "• **Antecedentes reportados**:\n";
    bool hasHigherRisk = false;
    
    for (int condition in conditions) {
      switch (condition) {
        case 0:
          text += "  - **Hipertensión arterial**: La presión alta puede afectar la FC. Mantén tu presión controlada.\n";
          if (hr > 90) hasHigherRisk = true;
          break;
        case 1:
          text += "  - **Diabetes mellitus**: La diabetes puede dañar los nervios que controlan el corazón.\n";
          if (hr > 95) hasHigherRisk = true;
          break;
        case 2:
          text += "  - **Colesterol alto**: Aumenta el riesgo de aterosclerosis.\n";
          break;
        case 3:
          text += "  - **Insuficiencia cardíaca**: El corazón bombea con menos eficiencia.\n";
          if (hr > 90) hasHigherRisk = true;
          break;
        case 4:
          text += "  - **Infarto previo**: Muy importante mantener controles cardiológicos regulares.\n";
          break;
        case 5:
          text += "  - **Arritmias diagnosticadas**: Esta medición es especialmente importante para ti.\n";
          break;
        case 6:
          text += "  - **Cardiopatía congénita**: Requiere seguimiento cardiológico especializado.\n";
          break;
        case 7:
          text += "  - **Tabaquismo**: El cigarrillo aumenta la FC (entre 10-20 lpm) y daña las arterias.\n";
          if (hr > 85) hasHigherRisk = true;
          break;
      }
      text += "\n";
    }
    
    if (hasHigherRisk && hr > 90) {
      text += "\n  **⚠️ Correlación importante**: Tu FC elevada ($hr lpm) junto con tus antecedentes sugiere que deberías consultar a un médico.\n";
    }
    text += "\n";
    return text;
  }
  
  static String _getSymptomsCorrelation(int hr, int symptoms) {
    switch (symptoms) {
      case 1:
        return "• **Síntoma (Palpitaciones)**: Las palpitaciones junto con tu FC de $hr lpm podrían indicar extrasístoles o ansiedad.\n\n";
      case 2:
        return "• **⚠️ Síntoma (Dolor en el pecho)**: ¡ESTE SÍNTOMA ES DE ALERTA! El dolor torácico con FC $hr lpm requiere evaluación médica inmediata.\n\n";
      case 3:
        if (hr < 60) {
          return "• **Síntoma (Mareos + FC baja)**: Los mareos con bradicardia ($hr lpm) son preocupantes.\n\n";
        }
        return "• **Síntoma (Mareos)**: Los mareos pueden deberse a deshidratación o bajada de presión.\n\n";
      case 4:
        if (hr > 90) {
          return "• **Síntoma (Falta de aire + FC elevada)**: La disnea con taquicardia ($hr lpm) sugiere evaluación médica.\n\n";
        }
        return "• **Síntoma (Falta de aire)**: Tu FC es normal, la falta de aire puede tener causa respiratoria.\n\n";
      case 5:
        return "• **Síntoma (Fatiga extrema)**: La fatiga con FC $hr lpm puede ser señal de anemia o tiroides.\n\n";
      default:
        return "• **Síntomas**: No reportaste síntomas en este momento.\n\n";
    }
  }
}
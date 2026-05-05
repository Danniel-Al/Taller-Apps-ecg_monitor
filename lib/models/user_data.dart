// lib/models/user_data.dart
// MODELO DE DATOS DEMOGRÁFICOS DEL USUARIO

class UserData {
  String username;
  bool hasCompletedDemographics;
  int ageRange;      // 0: 18-30, 1: 31-45, 2: 46-60, 3: 61-75, 4: >75
  int gender;        // 0: Femenino, 1: Masculino, 2: Prefiero no decirlo
  int conditions;    // 0: Ninguno, 1: Hipertensión, 2: Insuficiencia cardíaca, etc.
  int symptoms;      // 0: Ninguno, 1: Palpitaciones, 2: Dolor pecho, etc.
  int medications;   // 0: Ninguno, 1: Betabloqueadores, 2: Antidepresivos, etc.

  UserData({
    required this.username,
    this.hasCompletedDemographics = false,
    this.ageRange = 0,
    this.gender = 0,
    this.conditions = 0,
    this.symptoms = 0,
    this.medications = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'hasCompletedDemographics': hasCompletedDemographics,
      'ageRange': ageRange,
      'gender': gender,
      'conditions': conditions,
      'symptoms': symptoms,
      'medications': medications,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      username: map['username'],
      hasCompletedDemographics: map['hasCompletedDemographics'] ?? false,
      ageRange: map['ageRange'] ?? 0,
      gender: map['gender'] ?? 0,
      conditions: map['conditions'] ?? 0,
      symptoms: map['symptoms'] ?? 0,
      medications: map['medications'] ?? 0,
    );
  }
}


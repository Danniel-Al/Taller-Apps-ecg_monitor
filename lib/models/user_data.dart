// lib/models/user_data.dart
// MODELO DE DATOS DEMOGRÁFICOS DEL USUARIO

class UserData {
  String username;
  bool hasCompletedDemographics;
  int ageRange;
  int gender;
  int conditions;
  int symptoms;
  int medications;

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





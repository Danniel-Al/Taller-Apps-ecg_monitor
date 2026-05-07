// lib/models/user_data.dart


class UserData {
  String username;
  bool hasCompletedDemographics;
  int ageRange;
  int gender;
  List<int> conditions;
  int symptoms;
  int medications;

  UserData({
    required this.username,
    this.hasCompletedDemographics = false,
    this.ageRange = 0,
    this.gender = 0,
    this.conditions = const [],
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
      conditions: List<int>.from(map['conditions'] ?? []),
      symptoms: map['symptoms'] ?? 0,
      medications: map['medications'] ?? 0,
    );
  }

  String getConditionsText() {
    if (conditions.isEmpty) {
      return 'Ninguno';
    }
    final List<String> names = [];
    for (int i in conditions) {
      if (i == 0) {
        names.add('Hipertensión');
      } else if (i == 1) {
        names.add('Diabetes');
      } else if (i == 2) {
        names.add('Colesterol alto');
      } else if (i == 3) {
        names.add('Insuficiencia cardíaca');
      } else if (i == 4) {
        names.add('Infarto previo');
      } else if (i == 5) {
        names.add('Arritmias');
      } else if (i == 6) {
        names.add('Cardiopatía congénita');
      } else if (i == 7) {
        names.add('Tabaquismo');
      }
    }
    return names.join(', ');
  }
}
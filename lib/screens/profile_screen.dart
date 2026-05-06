// lib/screens/profile_screen.dart
// PANTALLA DE PERFIL DEL USUARIO
// AHORA RECIBE EL USERNAME DESDE LOGIN

import 'package:flutter/material.dart';
import '../models/user_data.dart';
import 'update_demographic_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;  // ← NUEVO: Recibe el username

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData _userData = UserData(
    username: '',
    hasCompletedDemographics: true,
    ageRange: 0,
    gender: 0,
    conditions: 0,
    symptoms: 0,
    medications: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // TODO: Cargar desde SharedPreferences
    // Por ahora usamos el username recibido y datos de ejemplo
    setState(() {
      _userData = UserData(
        username: widget.username,  // ← USA EL USERNAME REAL
        hasCompletedDemographics: true,
        ageRange: 2,      // 46-60 años
        gender: 0,        // Femenino
        conditions: 1,    // Hipertensión
        symptoms: 0,      // Ningún síntoma
        medications: 0,   // Ninguno
      );
    });
  }

  void _editDemographics() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateDemographicScreen(userData: _userData),
      ),
    );

    if (updated != null && updated == true) {
      _loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos actualizados correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de bienvenida con username real
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade50, Colors.red.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.red, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${_userData.username}',  // ← USERNAME REAL
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const Text(
                        'Aquí puedes ver y editar tus datos',
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _editDemographics,
                icon: const Icon(Icons.edit),
                label: const Text('Editar datos demográficos'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Colors.red.shade300),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Tus datos actuales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            _buildInfoCard('👤 Nombre de usuario', _userData.username),  // ← USERNAME REAL
            _buildInfoCard('🎂 Edad', _getAgeRangeText()),
            _buildInfoCard('👤 Sexo', _getGenderText()),
            _buildInfoCard('❤️ Antecedentes', _getConditionsText()),
            _buildInfoCard('🤒 Síntomas', _getSymptomsText()),
            _buildInfoCard('💊 Medicamentos', _getMedicationsText()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  String _getAgeRangeText() {
    const ranges = ['18-30 años', '31-45 años', '46-60 años', '61-75 años', '>75 años'];
    return ranges[_userData.ageRange];
  }

  String _getGenderText() {
    const genders = ['Femenino', 'Masculino', 'Prefiero no decirlo'];
    return genders[_userData.gender];
  }

  String _getConditionsText() {
    const conditions = [
      'Ninguno',
      'Hipertensión arterial',
      'Insuficiencia cardíaca',
      'Infarto previo',
      'Arritmias diagnosticadas',
      'Cardiopatía congénita'
    ];
    return conditions[_userData.conditions];
  }

  String _getSymptomsText() {
    const symptoms = [
      'Ningún síntoma',
      'Palpitaciones',
      'Dolor en el pecho',
      'Mareos / desmayos',
      'Falta de aire'
    ];
    return symptoms[_userData.symptoms];
  }

  String _getMedicationsText() {
    const medications = [
      'Ninguno',
      'Betabloqueadores',
      'Antidepresivos',
      'Antiarrítmicos',
      'Diuréticos'
    ];
    return medications[_userData.medications];
  }
}
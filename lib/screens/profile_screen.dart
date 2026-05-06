// lib/screens/profile_screen.dart
// PANTALLA DE PERFIL DEL USUARIO

import 'package:flutter/material.dart';
import '../models/user_data.dart';
import 'update_demographic_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData _userData = UserData(username: '');

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userData = UserData(
        username: widget.username,
        hasCompletedDemographics: true,
        ageRange: 2,
        gender: 0,
        conditions: 1,
        symptoms: 0,
        medications: 0,
      );
    });
  }

  Future<void> _editDemographics() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UpdateDemographicScreen(userData: _userData)),
    );
    if (updated == true) {
      _loadUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados'), backgroundColor: Colors.green),
      );
    }
  }

  String _getAgeRangeText() => const ['18-30 años', '31-45 años', '46-60 años', '61-75 años', '>75 años'][_userData.ageRange];
  String _getGenderText() => const ['Femenino', 'Masculino', 'Prefiero no decirlo'][_userData.gender];
  String _getConditionsText() => const ['Ninguno', 'Hipertensión', 'Insuficiencia cardíaca', 'Infarto previo', 'Arritmias', 'Cardiopatía congénita'][_userData.conditions];
  String _getSymptomsText() => const ['Ningún síntoma', 'Palpitaciones', 'Dolor en el pecho', 'Mareos', 'Falta de aire'][_userData.symptoms];
  String _getMedicationsText() => const ['Ninguno', 'Betabloqueadores', 'Antidepresivos', 'Antiarrítmicos', 'Diuréticos'][_userData.medications];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red.shade50, Colors.red.shade100]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.red, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hola, ${_userData.username}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      const Text('Aquí puedes ver y editar tus datos', style: TextStyle(fontSize: 12)),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.red.shade300)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tus datos actuales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 16),
            _buildInfoCard('👤 Nombre de usuario', _userData.username),
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
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.black54))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
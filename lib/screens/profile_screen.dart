// lib/screens/profile_screen.dart
// CON CIERRE DE SESIÓN QUE LIMPIA EL HISTORIAL DEL USUARIO

import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../services/memory_history_service.dart';
import 'update_demographic_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData _userData = UserData(username: '', conditions: []);

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
        conditions: [0, 7],
        symptoms: 0,
        medications: 0,
      );
    });
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión? Tu historial de mediciones se mantendrá guardado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Limpiar el usuario actual del servicio de historial
              MemoryHistoryService.clearCurrentUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
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
  String _getSymptomsText() => const ['Ningún síntoma', 'Palpitaciones', 'Dolor en el pecho', 'Mareos', 'Falta de aire', 'Fatiga extrema'][_userData.symptoms];
  String _getMedicationsText() => const ['Ninguno', 'Betabloqueadores', 'Antidepresivos', 'Antiarrítmicos', 'Diuréticos'][_userData.medications];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.person, color: Colors.red, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hola, ${_userData.username}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                      const Text('Aquí puedes ver y editar tus datos', style: TextStyle(fontSize: 12, color: Colors.black54)),
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tus datos actuales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 16),
            _buildInfoCard('👤 Nombre de usuario', _userData.username),
            _buildInfoCard('🎂 Edad', _getAgeRangeText()),
            _buildInfoCard('👤 Sexo', _getGenderText()),
            _buildInfoCard('❤️ Antecedentes', _userData.getConditionsText()),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.black54))),
            Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500), textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}

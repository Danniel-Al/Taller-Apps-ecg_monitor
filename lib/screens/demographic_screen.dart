// lib/screens/demographic_screen.dart
// Pantalla de recolección de datos demográficos (solo primera vez)

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/user_data.dart';
import 'home_screen.dart';

class DemographicScreen extends StatefulWidget {
  final String username;  // Recibe el nombre del usuario que inició sesión

  const DemographicScreen({super.key, required this.username});

  @override
  State<DemographicScreen> createState() => _DemographicScreenState();
}

class _DemographicScreenState extends State<DemographicScreen> {
  // Valores seleccionados por el usuario (índices)
  int _selectedAgeRange = 0;
  int _selectedGender = 0;
  int _selectedConditions = 0;
  int _selectedSymptoms = 0;
  int _selectedMedications = 0;

  // Controlador para el indicador de carga
  bool _isLoading = false;

  // Guardar datos y continuar a Home
  void _saveAndContinue() async {
    setState(() {
      _isLoading = true;
    });

    // Crear objeto con los datos del usuario
    final userData = UserData(
      username: widget.username,
      hasCompletedDemographics: true,
      ageRange: _selectedAgeRange,
      gender: _selectedGender,
      conditions: _selectedConditions,
      symptoms: _selectedSymptoms,
      medications: _selectedMedications,
    );

    // TODO: Guardar en SharedPreferences (próximo paso)
    // Por ahora solo simulamos un pequeño retraso

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navegar a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos personales'),
        automaticallyImplyLeading: false,  // Sin flecha de retroceso
        backgroundColor: Colors.red,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(  // Permite scroll si el contenido es largo
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mensaje de bienvenida
                  Text(
                    'Hola ${widget.username}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Para ofrecerte recomendaciones personalizadas, necesitamos algunos datos:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // ========== SELECTOR: EDAD ==========
                  const Text('Edad:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedAgeRange,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ageRanges.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAgeRange = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // ========== SELECTOR: SEXO ==========
                  const Text('Sexo:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: genders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // ========== SELECTOR: ANTECEDENTES ==========
                  const Text('Antecedentes cardíacos:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedConditions,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: conditionsList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedConditions = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // ========== SELECTOR: SÍNTOMAS ==========
                  const Text('Síntomas actuales:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedSymptoms,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: symptomsList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSymptoms = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // ========== SELECTOR: MEDICAMENTOS ==========
                  const Text('Medicamentos:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedMedications,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: medicationsList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMedications = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 32),

                  // ========== BOTÓN CONTINUAR ==========
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAndContinue,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

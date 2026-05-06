// lib/screens/demographic_screen.dart
// PANTALLA DE DATOS DEMOGRÁFICOS (SOLO PRIMERA VEZ)

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class DemographicScreen extends StatefulWidget {
  final String username;
  const DemographicScreen({super.key, required this.username});

  @override
  State<DemographicScreen> createState() => _DemographicScreenState();
}

class _DemographicScreenState extends State<DemographicScreen> {
  int _selectedAgeRange = 0;
  int _selectedGender = 0;
  int _selectedConditions = 0;
  int _selectedSymptoms = 0;
  int _selectedMedications = 0;
  bool _isLoading = false;

  void _saveAndContinue() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            username: widget.username,
            ageRange: _selectedAgeRange,
            gender: _selectedGender,
            conditions: _selectedConditions,
            symptoms: _selectedSymptoms,
            medications: _selectedMedications,
          ),
        ),
      );
    }
  }

  Widget _buildSelector({
    required String label,
    required String icon,
    required int value,
    required List<String> items,
    required Function(int) onChanged,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Text(icon, style: const TextStyle(fontSize: 22)), const SizedBox(width: 12), Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red))]),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: value,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: items.asMap().entries.map((entry) => DropdownMenuItem<int>(value: entry.key, child: Text(entry.value))).toList(),
              onChanged: (val) => onChanged(val!),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Datos personales', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.red, Color(0xFFE53935)]))),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red.shade50, Colors.red.shade100]), borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Text('¡Hola ${widget.username}! 👋', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFC62828))),
                        const SizedBox(height: 8),
                        const Text('Para ofrecerte recomendaciones personalizadas y un seguimiento más preciso, necesitamos conocer algunos datos sobre ti.', style: TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSelector(label: 'Edad', icon: '🎂', value: _selectedAgeRange, items: ageRanges, onChanged: (val) => setState(() => _selectedAgeRange = val)),
                  _buildSelector(label: 'Sexo', icon: '👤', value: _selectedGender, items: genders, onChanged: (val) => setState(() => _selectedGender = val)),
                  _buildSelector(label: 'Antecedentes cardíacos', icon: '❤️', value: _selectedConditions, items: conditionsList, onChanged: (val) => setState(() => _selectedConditions = val)),
                  _buildSelector(label: 'Síntomas actuales', icon: '🤒', value: _selectedSymptoms, items: symptomsList, onChanged: (val) => setState(() => _selectedSymptoms = val)),
                  _buildSelector(label: 'Medicamentos', icon: '💊', value: _selectedMedications, items: medicationsList, onChanged: (val) => setState(() => _selectedMedications = val)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveAndContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.red.shade300, width: 1.5)),
                      ),
                      child: const Text('Continuar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
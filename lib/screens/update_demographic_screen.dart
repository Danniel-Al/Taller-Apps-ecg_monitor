// lib/screens/update_demographic_screen.dart
// PANTALLA PARA EDITAR DATOS DEMOGRÁFICOS

import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/user_data.dart';

class UpdateDemographicScreen extends StatefulWidget {
  final UserData userData;
  const UpdateDemographicScreen({super.key, required this.userData});

  @override
  State<UpdateDemographicScreen> createState() => _UpdateDemographicScreenState();
}

class _UpdateDemographicScreenState extends State<UpdateDemographicScreen> {
  late int _selectedAgeRange;
  late int _selectedGender;
  late int _selectedConditions;
  late int _selectedSymptoms;
  late int _selectedMedications;

  @override
  void initState() {
    super.initState();
    _selectedAgeRange = widget.userData.ageRange;
    _selectedGender = widget.userData.gender;
    _selectedConditions = widget.userData.conditions;
    _selectedSymptoms = widget.userData.symptoms;
    _selectedMedications = widget.userData.medications;
  }

  void _saveChanges() => Navigator.pop(context, true);

  Widget _buildSelector({
    required String label,
    required String icon,
    required int value,
    required List<String> items,
    required Function(int) onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Text(icon, style: const TextStyle(fontSize: 20)), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red))]),
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
        title: const Text('Editar datos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSelector(label: 'Edad', icon: '🎂', value: _selectedAgeRange, items: ageRanges, onChanged: (val) => setState(() => _selectedAgeRange = val)),
            _buildSelector(label: 'Sexo', icon: '👤', value: _selectedGender, items: genders, onChanged: (val) => setState(() => _selectedGender = val)),
            _buildSelector(label: 'Antecedentes cardíacos', icon: '❤️', value: _selectedConditions, items: conditionsList, onChanged: (val) => setState(() => _selectedConditions = val)),
            _buildSelector(label: 'Síntomas actuales', icon: '🤒', value: _selectedSymptoms, items: symptomsList, onChanged: (val) => setState(() => _selectedSymptoms = val)),
            _buildSelector(label: 'Medicamentos', icon: '💊', value: _selectedMedications, items: medicationsList, onChanged: (val) => setState(() => _selectedMedications = val)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Guardar cambios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
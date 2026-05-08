// lib/screens/update_demographic_screen.dart


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
  late List<bool> _selectedConditions;
  late int _selectedSymptoms;
  late int _selectedMedications;

  @override
  void initState() {
    super.initState();
    _selectedAgeRange = widget.userData.ageRange;
    _selectedGender = widget.userData.gender;
    _selectedConditions = List.filled(conditionsList.length, false);
    for (int condition in widget.userData.conditions) {
      if (condition < _selectedConditions.length) {
        _selectedConditions[condition] = true;
      }
    }
    _selectedSymptoms = widget.userData.symptoms;
    _selectedMedications = widget.userData.medications;
  }

  void _saveChanges() {
    List<int> selectedIndexes = [];
    for (int i = 0; i < _selectedConditions.length; i++) {
      if (_selectedConditions[i]) selectedIndexes.add(i);
    }
    Navigator.pop(context, true);




























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
            _buildSelector('Edad', '🎂', _selectedAgeRange, ageRanges, (val) => setState(() => _selectedAgeRange = val)),
            const SizedBox(height: 16),
            _buildSelector('Sexo', '👤', _selectedGender, genders, (val) => setState(() => _selectedGender = val)),
            const SizedBox(height: 16),
            _buildConditionsCheckbox(),
            const SizedBox(height: 16),
            _buildSelector('Síntomas', '🤒', _selectedSymptoms, symptomsList, (val) => setState(() => _selectedSymptoms = val)),
            const SizedBox(height: 16),
            _buildSelector('Medicamentos', '💊', _selectedMedications, medicationsList, (val) => setState(() => _selectedMedications = val)),
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

  Widget _buildSelector(String label, String icon, int value, List<String> items, Function(int) onChanged) {
    return Card(
      elevation: 2,
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

  Widget _buildConditionsCheckbox() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const Text('❤️', style: TextStyle(fontSize: 22)), const SizedBox(width: 12), const Text('Antecedentes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red))]),
            const SizedBox(height: 12),
            ...List.generate(conditionsList.length, (index) => CheckboxListTile(
              value: _selectedConditions[index],
              onChanged: (bool? val) => setState(() => _selectedConditions[index] = val ?? false),
              title: Text(conditionsList[index]),
              activeColor: Colors.red,
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            )),
          ],
        ),
      ),
    );
  }
}
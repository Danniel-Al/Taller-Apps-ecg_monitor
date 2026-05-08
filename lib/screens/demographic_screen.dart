
// lib/screens/demographic_screen.dart
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
  List<bool> _selectedConditions = List.filled(conditionsList.length, false);
  int _selectedSymptoms = 0;
  int _selectedMedications = 0;
  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _steps = ['Edad y Sexo', 'Antecedentes', 'Síntomas', 'Medicamentos'];

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _saveAndContinue();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _saveAndContinue() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    List<int> selectedConditionsIndexes = [];
    for (int i = 0; i < _selectedConditions.length; i++) {
      if (_selectedConditions[i]) {
        selectedConditionsIndexes.add(i);
      }
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            username: widget.username,
            ageRange: _selectedAgeRange,
            gender: _selectedGender,
            conditions: selectedConditionsIndexes,
            symptoms: _selectedSymptoms,
            medications: _selectedMedications,
          ),
        ),
      );
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return Column(
          children: [
            _buildSelector('Edad', '🎂', _selectedAgeRange, ageRanges, (val) => setState(() => _selectedAgeRange = val)),
            const SizedBox(height: 16),
            _buildSelector('Sexo', '👤', _selectedGender, genders, (val) => setState(() => _selectedGender = val)),
          ],
        );
      case 1:
        return _buildConditionsCheckbox();
      case 2:
        return _buildSelector('Síntomas actuales', '🤒', _selectedSymptoms, symptomsList, (val) => setState(() => _selectedSymptoms = val));
      case 3:
        return Column(
          children: [
            _buildSelector('Medicamentos', '💊', _selectedMedications, medicationsList, (val) => setState(() => _selectedMedications = val)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '¡Ya casi terminas! Estos datos nos ayudarán a darte recomendaciones más precisas.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildConditionsCheckbox() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('❤️', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Antecedentes cardíacos y factores de riesgo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Selecciona TODOS los que apliquen:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            ...List.generate(conditionsList.length, (index) {
              return CheckboxListTile(
                value: _selectedConditions[index],
                onChanged: (bool? value) => setState(() => _selectedConditions[index] = value ?? false),
                title: Text(conditionsList[index]),
                activeColor: Colors.red,
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Puedes seleccionar múltiples opciones. Esto ayuda a evaluar mejor tu riesgo cardiovascular.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
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
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: DropdownButtonFormField<int>(
                initialValue: value,
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                items: items.asMap().entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (val) => onChanged(val!),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tus datos', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person_add, color: Colors.red, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '¡Hola ${widget.username}!',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                const Text(
                                  'Cuéntanos sobre ti para recomendaciones personalizadas',
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_steps.length, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: index <= _currentStep
                                          ? Colors.red
                                          : Colors.grey.shade300,
                                    ),
                                    child: Center(
                                      child: index < _currentStep
                                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                                          : Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: index <= _currentStep
                                                    ? Colors.white
                                                    : Colors.grey.shade600,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _steps[index],
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 8 : 10,
                                      color: index <= _currentStep
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildStepContent(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Anterior'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(_currentStep == 3 ? 'Finalizar' : 'Siguiente'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

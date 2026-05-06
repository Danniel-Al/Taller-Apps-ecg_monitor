// lib/screens/calibration_screen.dart
// PANTALLA DE CALIBRACIÓN

import 'package:flutter/material.dart';
import 'measuring_screen.dart';

class CalibrationScreen extends StatefulWidget {
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;

  const CalibrationScreen({
    super.key,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
  });

  @override
  State<CalibrationScreen> createState() => _CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _startCalibration();
  }

  void _startCalibration() async {
    for (int i = 3; i >= 0; i--) {
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MeasuringScreen(
            ageRange: widget.ageRange,
            gender: widget.gender,
            conditions: widget.conditions,
            symptoms: widget.symptoms,
            medications: widget.medications,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Prepárate para la medición', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
              child: const Column(
                children: [
                  Text('📌', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 8),
                  Text('• Siéntate cómodamente\n• No hables ni te muevas\n• Respira normalmente', style: TextStyle(fontSize: 14, height: 1.5), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 48),
            if (_countdown > 0)
              Text('$_countdown', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.red))
            else
              const Column(children: [CircularProgressIndicator(color: Colors.red), SizedBox(height: 16), Text('Iniciando medición...', style: TextStyle(fontSize: 16))]),
          ],
        ),
      ),
    );
  }
}
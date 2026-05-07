// lib/screens/calibration_screen.dart
// PANTALLA DE CALIBRACIÓN - VERSIÓN CENTRADA PARA TELÉFONO

import 'package:flutter/material.dart';
import 'measuring_screen.dart';

class CalibrationScreen extends StatefulWidget {
  final int ageRange;
  final int gender;
  final List<int> conditions;
  final int symptoms;
  final int medications;
  final String username;

  const CalibrationScreen({
    super.key,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
    required this.username,
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
            username: widget.username,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título
              Text(
                'Prepárate para la medición',
                style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Tarjeta de instrucciones
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('📌', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 12),
                    Text(
                      '• Siéntate cómodamente\n'
                      '• No hables ni te muevas\n'
                      '• Respira normalmente\n'
                      '• Coloca tus dedos sobre el sensor',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Contador o indicador de carga
              if (_countdown > 0)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$_countdown',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 64 : 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )
              else
                const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Iniciando medición...',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

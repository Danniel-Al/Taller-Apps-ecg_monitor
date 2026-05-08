// lib/screens/measurement_screen.dart

import 'package:flutter/material.dart';
import 'calibration_screen.dart';

class MeasurementScreen extends StatefulWidget {
  final int ageRange;
  final int gender;
  final List<int> conditions;
  final int symptoms;
  final int medications;
  final String username;

  const MeasurementScreen({
    super.key,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
    required this.username,
  });

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  size: 64,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Medición de frecuencia cardíaca',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Antes de comenzar, te guiaremos con una breve calibración para obtener una medición más precisa.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CalibrationScreen(
                          ageRange: widget.ageRange,
                          gender: widget.gender,
                          conditions: widget.conditions,
                          symptoms: widget.symptoms,
                          medications: widget.medications,
                          username: widget.username,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Iniciar calibración',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

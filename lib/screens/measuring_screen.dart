<<<<<<< HEAD
// lib/screens/measurement_screen.dart
// PANTALLA PRINCIPAL DE MEDICIÓN
=======
// lib/screens/measuring_screen.dart
// PANTALLA DE MEDICIÓN ACTIVA (SIMULACIÓN DE LATIDOS)
// CORREGIDO: Corazón centrado vertical y horizontalmente
>>>>>>> 271b0d5dbf5fac301c4a25fca77c3225f95c5cd6

import 'package:flutter/material.dart';
import 'calibration_screen.dart';

class MeasurementScreen extends StatefulWidget {
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;

  const MeasurementScreen({
    super.key,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
  });

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

<<<<<<< HEAD
class _MeasurementScreenState extends State<MeasurementScreen> {
=======
class _MeasuringScreenState extends State<MeasuringScreen>
    with SingleTickerProviderStateMixin {
  int _timeRemaining = 30; // 30 segundos de medición
  int _heartBeats = 0; // Latidos detectados (simulados)
  bool _isMeasuring = true;
  late Timer _timer;
  late Timer _heartBeatSimulator;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _startMeasurement();

    // Animación para el latido del corazón
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _startMeasurement() {
    // Timer principal: cuenta regresiva de 30 segundos
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 1) {
          _timeRemaining--;
        } else {
          _stopMeasurement();
        }
      });
    });

    // Simulador de latidos (cada 0.8 segundos = ~75 lpm)
    _heartBeatSimulator = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_isMeasuring) {
        setState(() {
          _heartBeats++;
        });
        _animateHeartBeat(); // Efecto visual
      }
    });
  }

  void _animateHeartBeat() {
    _animationController.forward(from: 0.0);
  }

  void _stopMeasurement() {
    _isMeasuring = false;
    _timer.cancel();
    _heartBeatSimulator.cancel();
    _animationController.dispose();

    // Calcular frecuencia cardíaca: latidos en 30s * 2 = lpm
    int heartRate = (_heartBeats * 2).clamp(40, 180).toInt();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(heartRate: heartRate),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _heartBeatSimulator.cancel();
    _animationController.dispose();
    super.dispose();
  }

>>>>>>> 271b0d5dbf5fac301c4a25fca77c3225f95c5cd6
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
<<<<<<< HEAD
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, size: 64, color: Colors.red),
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
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Iniciar calibración',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
=======
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Título
              const Text(
                'Midiendo frecuencia cardíaca',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Temporizador
              Text(
                '${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Latidos detectados
              Text(
                'Latidos detectados: $_heartBeats',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              // ESPACIO FLEXIBLE para centrar el corazón
              const Expanded(child: SizedBox()),

              // ========== CORAZÓN CENTRADO ==========
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final scale = 1.0 + (_animationController.value * 0.3);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          size: 80,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
>>>>>>> 271b0d5dbf5fac301c4a25fca77c3225f95c5cd6
                ),
              ),

              // ESPACIO FLEXIBLE para mantener centrado
              const Expanded(child: SizedBox()),

              // Mensaje de instrucción
              const Text(
                'Mantén tus dedos quietos sobre el sensor',
                style: TextStyle(fontSize: 14, color: Colors.black45),
              ),
              const SizedBox(height: 16),

              // Botón cancelar
              TextButton(
                onPressed: _stopMeasurement,
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red.shade300),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}




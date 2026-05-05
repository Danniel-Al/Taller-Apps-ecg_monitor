// lib/screens/measuring_screen.dart
// PANTALLA DE MEDICIÓN ACTIVA (SIMULACIÓN DE LATIDOS)

import 'dart:async';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class MeasuringScreen extends StatefulWidget {
  const MeasuringScreen({super.key});

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen> {
  int _timeRemaining = 30;  // 30 segundos de medición
  int _heartBeats = 0;      // Latidos detectados (simulados)
  bool _isMeasuring = true;
  late Timer _timer;
  late Timer _heartBeatSimulator;

  @override
  void initState() {
    super.initState();
    _startMeasurement();
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
        _animateHeartBeat();  // Efecto visual
      }
    });
  }

  void _stopMeasurement() {
    _isMeasuring = false;
    _timer.cancel();
    _heartBeatSimulator.cancel();

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

  void _animateHeartBeat() {
    // Efecto visual del latido (se puede implementar con animación)
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    _heartBeatSimulator.cancel();
    super.dispose();
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
            // Título
            const Text(
              'Midiendo frecuencia cardíaca',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Temporizador
            Text(
              '${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Corazón animado (cambia de tamaño según latidos)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(_isMeasuring && _heartBeats % 2 == 0 ? 20 : 30),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                size: _isMeasuring && _heartBeats % 2 == 0 ? 60 : 80,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 32),

            // Latidos detectados
            Text(
              'Latidos detectados: $_heartBeats',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Mensaje de instrucción
            const Text(
              'Mantén tus dedos quietos sobre el sensor',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
            const SizedBox(height: 24),

            // Botón cancelar (opcional)
            TextButton(
              onPressed: _stopMeasurement,
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.red.shade300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

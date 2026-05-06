// lib/screens/measuring_screen.dart
// PANTALLA DE MEDICIÓN ACTIVA

import 'dart:async';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class MeasuringScreen extends StatefulWidget {
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;

  const MeasuringScreen({
    super.key,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
  });

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen> with SingleTickerProviderStateMixin {
  int _timeRemaining = 30;
  int _heartBeats = 0;
  bool _isMeasuring = true;
  late Timer _timer;
  late Timer _heartBeatSimulator;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _startMeasurement();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  void _startMeasurement() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 1) _timeRemaining--;
        else _stopMeasurement();
      });
    });
    _heartBeatSimulator = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (_isMeasuring) {
        setState(() => _heartBeats++);
        _animationController.forward(from: 0.0);
      }
    });
  }

  void _stopMeasurement() {
    _isMeasuring = false;
    _timer.cancel();
    _heartBeatSimulator.cancel();
    _animationController.dispose();
    int heartRate = (_heartBeats * 2).clamp(40, 180).toInt();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            heartRate: heartRate,
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
  void dispose() {
    _timer.cancel();
    _heartBeatSimulator.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text('Midiendo frecuencia cardíaca', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 8),
              Text('${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              Text('Latidos detectados: $_heartBeats', style: const TextStyle(fontSize: 14, color: Colors.black54)),
              const Expanded(child: SizedBox()),
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final scale = 1.0 + (_animationController.value * 0.3);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.favorite, size: 80, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              const Text('Mantén tus dedos quietos sobre el sensor', style: TextStyle(fontSize: 14, color: Colors.black45)),
              const SizedBox(height: 16),
              TextButton(onPressed: _stopMeasurement, child: Text('Cancelar', style: TextStyle(color: Colors.red.shade300))),
            ],
          ),
        ),
      ),
    );
  }
}
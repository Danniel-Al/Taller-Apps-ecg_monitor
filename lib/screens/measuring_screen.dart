// lib/screens/measuring_screen.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class MeasuringScreen extends StatefulWidget {
  final int ageRange;
  final int gender;
  final List<int> conditions;
  final int symptoms;
  final int medications;
  final String username;
  final String esp32Ip;

  const MeasuringScreen({
    super.key,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
    required this.username,
    this.esp32Ip = '172.20.10.12', // ← cambia si es necesario
  });

  @override
  State<MeasuringScreen> createState() => _MeasuringScreenState();
}

class _MeasuringScreenState extends State<MeasuringScreen>
    with SingleTickerProviderStateMixin {
  // ── Tiempo y latidos ──────────────────────────────────────────
  static const int _totalSeconds = 30;
  int _timeRemaining = _totalSeconds;
  int _heartBeats = 0;
  bool _isMeasuring = true;

  // ── Timers ────────────────────────────────────────────────────
  late Timer _countdownTimer;

  // ── Animación corazón ─────────────────────────────────────────
  late AnimationController _animationController;

  // ── TCP / Sensor ──────────────────────────────────────────────
  Socket? _socket;
  String _status = 'Conectando...';

  // ── Detección de picos (QRS) ──────────────────────────────────
  final List<double> _buffer = [];
  int _lastPeakIndex = -15;        // periodo refractario: 15 muestras (~75ms a 200Hz)
  static const double _threshold = 2500;
  static const int _refractory  = 15;
  int _sampleIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _connectAndListen();
    _startCountdown();
  }

  // ── Conexión TCP ──────────────────────────────────────────────
  Future<void> _connectAndListen() async {
    try {
      _socket = await Socket.connect(
        widget.esp32Ip, 8080,
        timeout: const Duration(seconds: 5),
      );
      if (mounted) setState(() => _status = 'Conectado');

      _socket!.cast<List<int>>().transform(utf8.decoder).listen(
        (data) {
          for (final line in data.trim().split('\n')) {
            final value = double.tryParse(line.trim());
            if (value == null || value < 0) continue; // -1 = electrodo suelto

            if (!_isMeasuring) return;

            _buffer.add(value);
            _detectPeak(value, _sampleIndex);
            _sampleIndex++;
          }
        },
        onError: (_) {
          if (mounted) setState(() => _status = 'Error de conexión');
        },
        onDone: () {
          if (mounted) setState(() => _status = 'Desconectado');
        },
      );
    } catch (e) {
      if (mounted) setState(() => _status = 'Sin conexión: $e');
    }
  }

  // ── Detección de pico QRS ─────────────────────────────────────
  void _detectPeak(double value, int index) {
    final int len = _buffer.length;
    if (len < 3) return;

    final double prev = _buffer[len - 3];
    final double curr = _buffer[len - 2];
    final double next = _buffer[len - 1]; // = value

    final bool isPeak = curr > prev &&
        curr > next &&
        curr > _threshold &&
        (index - 1 - _lastPeakIndex) > _refractory;

    if (isPeak) {
      _lastPeakIndex = index - 1;
      if (mounted) {
        setState(() => _heartBeats++);
        _animationController.forward(from: 0.0); // 💓 animar corazón
      }
    }
  }

  // ── Cuenta regresiva ──────────────────────────────────────────
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_timeRemaining > 1) {
          _timeRemaining--;
        } else {
          _stopMeasurement();
        }
      });
    });
  }

  // ── Finalizar medición ────────────────────────────────────────
  void _stopMeasurement() {
    if (!_isMeasuring) return;
    _isMeasuring = false;
    _countdownTimer.cancel();
    _socket?.destroy();

    // BPM = latidos en 30s → ×2
    final int heartRate = (_heartBeats * 2).clamp(40, 180);

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
            username: widget.username,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _animationController.dispose();
    _socket?.destroy();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Midiendo frecuencia cardíaca',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Estado de conexión
              Text(
                _status,
                style: TextStyle(
                    fontSize: 13,
                    color: _status == 'Conectado'
                        ? Colors.green
                        : Colors.orange),
              ),
              const SizedBox(height: 12),
              // Temporizador
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  '${_timeRemaining ~/ 60}:${(_timeRemaining % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Latidos detectados: $_heartBeats',
                style:
                    const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const Expanded(child: SizedBox()),
              // Corazón animado
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final scale =
                        1.0 + (_animationController.value * 0.3);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.favorite,
                            size: 80, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox()),
              const Text(
                'Mantén los electrodos bien colocados',
                style:
                    TextStyle(fontSize: 14, color: Colors.black45),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _stopMeasurement,
                child: Text('Cancelar medición',
                    style:
                        TextStyle(color: Colors.red.shade400)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

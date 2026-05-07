// lib/screens/recommendation_screen.dart
// PANTALLA DE RECOMENDACIÓN PERSONALIZADA

import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  final int heartRate;
  final String recommendation;

  const RecommendationScreen({
    super.key,
    required this.heartRate,
    required this.recommendation,
  });

  String _getStatusText() {
    if (heartRate < 60) return 'Bradicardia - Ritmo lento';
    if (heartRate > 100) return 'Taquicardia - Ritmo rápido';
    return 'Normal - Ritmo saludable';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recomendación', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red.shade400, Colors.red.shade700]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.medical_services, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  Text('Tu frecuencia cardíaca: $heartRate lpm', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
                    child: Text(_getStatusText(), style: const TextStyle(fontSize: 14, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.lightbulb, color: Colors.amber), SizedBox(width: 8), Text('Recomendación personalizada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red))]),
                  const Divider(height: 32),
                  Text(recommendation, style: const TextStyle(fontSize: 15, height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.red.shade300)),
                ),
                child: const Text('Volver', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


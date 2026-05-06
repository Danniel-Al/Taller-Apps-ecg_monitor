// lib/screens/result_screen.dart (VERSIÓN MODIFICADA)
// Recibe FC y datos del usuario para mostrar recomendación y comparación

import 'package:flutter/material.dart';
import '../services/recommendation_service.dart';
import '../services/comparison_service.dart';
import 'recommendation_screen.dart';
import 'comparison_screen.dart';

class ResultScreen extends StatelessWidget {
  final int heartRate;
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;

  const ResultScreen({
    super.key,
    required this.heartRate,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultado', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite, size: 64, color: _getStatusColor()),
            ),
            const SizedBox(height: 24),
            Text('$heartRate', style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.red)),
            const Text('latidos por minuto', style: TextStyle(fontSize: 16, color: Colors.black54)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _getStatusColor().withOpacity(0.3)),
              ),
              child: Text(_getStatusMessage(), textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _getStatusColor())),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final recommendation = RecommendationService.getRecommendation(
                    heartRate: heartRate,
                    ageRange: ageRange,
                    gender: gender,
                    conditions: conditions,
                    symptoms: symptoms,
                    medications: medications,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecommendationScreen(
                        heartRate: heartRate,
                        recommendation: recommendation,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Ver recomendación', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  final comparison = ComparisonService.compare(
                    heartRate: heartRate,
                    ageRange: ageRange,
                    gender: gender,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ComparisonScreen(comparison: comparison),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Comparar con demografía', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: Text('Nueva medición', style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusMessage() {
    if (heartRate < 60) return 'Bradicardia (Ritmo lento)';
    if (heartRate > 100) return 'Taquicardia (Ritmo rápido)';
    return 'Normal (Ritmo saludable)';
  }

  Color _getStatusColor() {
    if (heartRate < 60) return Colors.orange;
    if (heartRate > 100) return Colors.red;
    return Colors.green;
  }
}

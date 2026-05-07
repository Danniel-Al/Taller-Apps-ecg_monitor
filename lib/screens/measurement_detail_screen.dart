// lib/screens/measurement_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/measurement_record.dart';
import '../services/comparison_service.dart';
import 'recommendation_screen.dart';
import 'comparison_screen.dart';

class MeasurementDetailScreen extends StatelessWidget {
  final MeasurementRecord record;
  const MeasurementDetailScreen({super.key, required this.record});

  Color _getStatusColor() {
    if (record.heartRate < 60) return Colors.orange;
    if (record.heartRate > 100) return Colors.red;
    return Colors.green;
  }

  String _cleanText(String text) {
    return text.replaceAll('**', '').replaceAll('*', '');
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = record.heartRate < 60
        ? 'Bradicardia'
        : (record.heartRate > 100 ? 'Taquicardia' : 'Normal');
    
    final String cleanRecommendation = _cleanText(record.recommendation);
    final String cleanComparisonText = _cleanText(record.comparisonText);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalle', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '${record.dateTime.day}/${record.dateTime.month}/${record.dateTime.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '${record.dateTime.hour.toString().padLeft(2, '0')}:${record.dateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite,
                size: 64,
                color: _getStatusColor(),
              ),
            ),
            Text(
              '${record.heartRate}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Text(
              'latidos por minuto',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecommendationScreen(
                            heartRate: record.heartRate,
                            recommendation: record.recommendation,
                            ageRange: record.ageRange,
                            gender: record.gender,
                            conditions: record.conditions,
                            symptoms: record.symptoms,
                            medications: record.medications,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.medical_information),
                    label: const Text('Recomendación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final comparison = ComparisonService.getDetailedComparison(
                        heartRate: record.heartRate,
                        ageRange: record.ageRange,
                        gender: record.gender,
                        conditions: record.conditions,
                        symptoms: record.symptoms,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ComparisonScreen(
                            comparison: comparison,
                            heartRate: record.heartRate,
                            ageRange: record.ageRange,
                            gender: record.gender,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Comparar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📋 Resumen',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    cleanComparisonText,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Recomendación:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cleanRecommendation,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



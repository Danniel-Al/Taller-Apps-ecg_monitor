// lib/screens/measurement_detail_screen.dart
// DETALLE DE UNA MEDICIÓN GUARDADA

import 'package:flutter/material.dart';
import '../models/measurement_record.dart';
import '../services/recommendation_service.dart';
import '../services/comparison_service.dart';
import 'recommendation_screen.dart';
import 'comparison_screen.dart';

class MeasurementDetailScreen extends StatelessWidget {
  final MeasurementRecord record;

  const MeasurementDetailScreen({super.key, required this.record});

  String _getStatusText() {
    if (record.heartRate < 60) return 'Bradicardia (Ritmo lento)';
    if (record.heartRate > 100) return 'Taquicardia (Ritmo rápido)';
    return 'Normal (Ritmo saludable)';
  }

  Color _getStatusColor() {
    if (record.heartRate < 60) return Colors.orange;
    if (record.heartRate > 100) return Colors.red;
    return Colors.green;
  }

  String _formatDate() => '${record.dateTime.day}/${record.dateTime.month}/${record.dateTime.year}';
  String _formatTime() => '${record.dateTime.hour.toString().padLeft(2, '0')}:${record.dateTime.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Detalle de medición', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(_formatDate(), style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(_formatTime(), style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: _getStatusColor().withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.favorite, size: 64, color: _getStatusColor()),
            ),
            const SizedBox(height: 16),
            Text('${record.heartRate}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.red)),
            const Text('latidos por minuto', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(color: _getStatusColor().withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
              child: Text(_getStatusText(), style: TextStyle(fontSize: 14, color: _getStatusColor())),
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
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.medical_information),
                    label: const Text('Recomendación'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final comparison = ComparisonService.compare(
                        heartRate: record.heartRate,
                        ageRange: record.ageRange,
                        gender: record.gender,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ComparisonScreen(comparison: comparison),
                        ),
                      );
                    },
                    icon: const Icon(Icons.compare_arrows),
                    label: const Text('Comparar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📋 Resumen de la medición', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildInfoRow('Comparación', record.comparisonText),
                  const SizedBox(height: 8),
                  const Text('Recomendación:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(record.recommendation, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
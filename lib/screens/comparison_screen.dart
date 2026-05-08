// lib/screens/comparison_screen.dart
// VERSIÓN REDISEÑADA - COMO LA IMAGEN

import 'package:flutter/material.dart';
import '../services/comparison_service.dart';

class ComparisonScreen extends StatelessWidget {
  final DetailedComparison comparison;
  final int heartRate;
  final int ageRange;
  final int gender;

  const ComparisonScreen({
    super.key,
    required this.comparison,
    required this.heartRate,
    required this.ageRange,
    required this.gender,
  });

  Color _getStatusColor() {
    if (comparison.heartRate < 60) return Colors.orange;
    if (comparison.heartRate > comparison.maxNormal) return Colors.red;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Comparación por edad',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta 1: Información de tu medición
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tu medición',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${comparison.heartRate}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'lpm',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      comparison.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta 2: Comparación con tu grupo etario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.people, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Comparación con tu grupo etario',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Tu sexo', comparison.gender),
                  _buildInfoRow('Rango etario', '${comparison.ageGroup} años'),
                  _buildInfoRow('Rango normal esperado', '${comparison.minNormal} - ${comparison.maxNormal} lpm'),
                  _buildInfoRow('Rango ideal', '${comparison.idealMin} - ${comparison.idealMax} lpm'),
                  _buildInfoRow('Tu posición', comparison.percentile),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta 3: Interpretación y recomendaciones
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.medical_services, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Interpretación y recomendaciones',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getInterpretation(),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInterpretation() {
    String interpretation = '';
    
    if (comparison.heartRate >= comparison.minNormal && comparison.heartRate <= comparison.maxNormal) {
      interpretation += "✅ ¡Tu ritmo cardíaco es normal!\n\n";
      interpretation += "Para ${comparison.description} de tu grupo etario (${comparison.ageGroup} años), "
          "lo esperado es un rango de ${comparison.minNormal}-${comparison.maxNormal} lpm. "
          "Tu medición de ${comparison.heartRate} lpm está dentro de los parámetros saludables.\n\n";
      
      if (comparison.heartRate < comparison.idealMin) {
        interpretation += "💚 **Nota**: Tu ritmo está en la parte baja del rango normal. "
            "Esto puede ser señal de buena condición cardiovascular, especialmente si eres activo físicamente.\n\n";
      } else if (comparison.heartRate > comparison.idealMax) {
        interpretation += "💛 **Nota**: Aunque estás dentro del rango normal, tu ritmo está en la parte alta. "
            "Si no hiciste ejercicio antes de medirte, podrías beneficiarte de técnicas de relajación.\n\n";
      }
    } else if (comparison.heartRate < comparison.minNormal) {
      interpretation += "🧡 Tu ritmo cardíaco está por debajo de lo esperado (Bradicardia)\n\n";
      interpretation += "Para tu grupo etario (${comparison.ageGroup} años), el rango normal es de "
          "${comparison.minNormal}-${comparison.maxNormal} lpm. Tu medición de ${comparison.heartRate} lpm está por debajo.\n\n";
      interpretation += "**Esto puede significar:**\n";
      interpretation += "• Si eres deportista, puede ser una señal de excelente condición física.\n";
      interpretation += "• Si no haces ejercicio, podría indicar que tu corazón bombea con menos fuerza.\n\n";
    } else {
      interpretation += "❤️‍🔥 Tu ritmo cardíaco está por encima de lo esperado (Taquicardia)\n\n";
      interpretation += "Para tu grupo etario (${comparison.ageGroup} años), el rango normal es de "
          "${comparison.minNormal}-${comparison.maxNormal} lpm. Tu medición de ${comparison.heartRate} lpm supera este límite.\n\n";
      interpretation += "**Causas frecuentes temporales:**\n";
      interpretation += "• Estrés o ansiedad\n";
      interpretation += "• Cafeína o bebidas energéticas\n";
      interpretation += "• Deshidratación\n";
      interpretation += "• Fiebre o infección\n";
      interpretation += "• Ejercicio reciente\n\n";
    }
    
    interpretation += "\n---\n💙 **Recuerda**: Esta app es una herramienta de monitoreo. "
        "Si tienes dudas, consulta a un profesional de la salud.";
    
    return interpretation;
  }
}
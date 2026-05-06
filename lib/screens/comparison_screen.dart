// lib/screens/comparison_screen.dart
// PANTALLA QUE COMPARA LA FC CON RANGOS NORMALES POR EDAD

import 'package:flutter/material.dart';
import '../services/comparison_service.dart';

class ComparisonScreen extends StatelessWidget {
  final ComparisonResult comparison;

  const ComparisonScreen({super.key, required this.comparison});

  Color _getStatusColor() {
    switch (comparison.statusColor) {
      case 'verde':
        return Colors.green;
      case 'naranja':
        return Colors.orange;
      case 'rojo':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Comparación demográfica', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tarjeta principal con resumen
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade50, Colors.red.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bar_chart, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    'Tu FC: ${comparison.heartRate} lpm',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comparison.status,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _getStatusColor()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tarjeta de información demográfica
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📊 Datos de referencia',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _buildInfoRow('Sexo', comparison.gender),
                  _buildInfoRow('Rango etario', comparison.ageGroup),
                  _buildInfoRow('Rango normal', '${comparison.minNormal} - ${comparison.maxNormal} lpm'),
                  _buildInfoRow('Tu posición', comparison.percentile),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Gráfico de barras visual simplificado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📈 Comparación visual', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: comparison.minNormal,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green.shade200,
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                          ),
                          child: const Center(child: Text('Mín', style: TextStyle(fontSize: 10))),
                        ),
                      ),
                      Expanded(
                        flex: (comparison.maxNormal - comparison.minNormal),
                        child: Container(
                          height: 30,
                          color: Colors.green.shade400,
                          child: const Center(child: Text('Normal', style: TextStyle(fontSize: 10, color: Colors.white))),
                        ),
                      ),
                      Expanded(
                        flex: 100 - comparison.maxNormal,
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                          ),
                          child: const Center(child: Text('Max+', style: TextStyle(fontSize: 10))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: comparison.heartRate.clamp(0, 100) - 1,
                        child: Container(),
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.red,
                      ),
                      const Text('  Tu FC', style: TextStyle(fontSize: 10, color: Colors.red)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Explicación
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Los rangos normales pueden variar según actividad física, medicamentos y condiciones de salud.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Volver', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.black54))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}


// lib/screens/result_screen.dart
// SOLO GUARDA CUANDO EL USUARIO PRESIONA "GUARDAR Y SALIR"

import 'package:flutter/material.dart';
import '../services/recommendation_service.dart';
import '../services/comparison_service.dart';
import '../services/memory_history_service.dart';
import '../models/measurement_record.dart';
import 'recommendation_screen.dart';
import 'comparison_screen.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final int heartRate;
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;
  final String username;

  const ResultScreen({
    super.key,
    required this.heartRate,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
    required this.username,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _recommendation;
  late DetailedComparison _comparison;

  @override
  void initState() {
    super.initState();
    _recommendation = RecommendationService.getDetailedRecommendation(
      heartRate: widget.heartRate,
      ageRange: widget.ageRange,
      gender: widget.gender,
      conditions: widget.conditions,
      symptoms: widget.symptoms,
      medications: widget.medications,
    );
    _comparison = ComparisonService.getDetailedComparison(
      heartRate: widget.heartRate,
      ageRange: widget.ageRange,
      gender: widget.gender,
      conditions: widget.conditions,
      symptoms: widget.symptoms,
    );
  }

  void _saveMeasurement() {
    final record = MeasurementRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dateTime: DateTime.now(),
      heartRate: widget.heartRate,
      ageRange: widget.ageRange,
      gender: widget.gender,
      conditions: widget.conditions,
      symptoms: widget.symptoms,
      medications: widget.medications,
      recommendation: _recommendation,
      comparisonStatus: _comparison.status,
      comparisonText: '${_comparison.status} - ${_comparison.percentile}',
    );
    MemoryHistoryService.saveMeasurement(record);
  }

  void _goToRecommendation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationScreen(
          heartRate: widget.heartRate,
          recommendation: _recommendation,
          ageRange: widget.ageRange,
          gender: widget.gender,
          conditions: widget.conditions,
          symptoms: widget.symptoms,
          medications: widget.medications,
        ),
      ),
    );
  }

  void _goToComparison() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComparisonScreen(
          comparison: _comparison,
          heartRate: widget.heartRate,
          ageRange: widget.ageRange,
          gender: widget.gender,
        ),
      ),
    );
  }

  void _saveAndGoHome() {
    _saveMeasurement();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Medición guardada en tu historial'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          username: widget.username,
          ageRange: widget.ageRange,
          gender: widget.gender,
          conditions: widget.conditions,
          symptoms: widget.symptoms,
          medications: widget.medications,
        ),
      ),
      (route) => false,
    );
  }

  void _goToHomeWithoutSaving() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          username: widget.username,
          ageRange: widget.ageRange,
          gender: widget.gender,
          conditions: widget.conditions,
          symptoms: widget.symptoms,
          medications: widget.medications,
        ),
      ),
      (route) => false,
    );
  }

  String _getStatusText() {
    if (widget.heartRate < 60) return 'Bradicardia (Ritmo lento)';
    if (widget.heartRate > 100) return 'Taquicardia (Ritmo rápido)';
    return 'Normal (Ritmo saludable)';
  }

  Color _getStatusColor() {
    if (widget.heartRate < 60) return Colors.orange;
    if (widget.heartRate > 100) return Colors.red;
    return Colors.green;
  }

  String _getRecommendationSummary() {
    if (widget.heartRate < 60) {
      return 'Tu corazón late más lento de lo habitual. Puede ser normal si eres deportista, pero si tienes mareos o fatiga, consulta a tu médico.';
    } else if (widget.heartRate > 100) {
      return 'Tu corazón late más rápido de lo habitual. Esto puede deberse a estrés, cafeína o deshidratación. Si persiste, busca atención médica.';
    } else {
      return '¡Excelente! Tu frecuencia cardíaca está dentro del rango saludable. Mantén tus buenos hábitos.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultado', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  size: isSmallScreen ? 70 : 90,
                  color: _getStatusColor(),
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                '${widget.heartRate}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 56 : 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const Text(
                'latidos por minuto',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: _getStatusColor(), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getRecommendationSummary(),
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botón: Ver recomendación completa (NO guarda)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _goToRecommendation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Ver recomendación completa',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Botón: Comparar con tu grupo de edad (NO guarda)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _goToComparison,
                  icon: const Icon(Icons.people_outline),
                  label: const Text(
                    'Comparar con tu grupo de edad',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade300, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Botón: Guardar y salir (ÚNICO QUE GUARDA)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveAndGoHome,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Guardar y salir',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Botón: Salir sin guardar
              TextButton.icon(
                onPressed: _goToHomeWithoutSaving,
                icon: const Icon(Icons.exit_to_app, size: 18),
                label: const Text(
                  'Salir sin guardar',
                  style: TextStyle(fontSize: 14),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

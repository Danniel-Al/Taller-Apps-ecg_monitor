// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import '../services/recommendation_service.dart';
import '../services/comparison_service.dart';
import '../services/correlation_service.dart';
import '../services/memory_history_service.dart';
import '../models/measurement_record.dart';
import 'recommendation_screen.dart';
import 'comparison_screen.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final int heartRate;
  final int ageRange;
  final int gender;
  final List<int> conditions;
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
  late String _correlationAnalysis;

  String _cleanText(String text) {
    return text.replaceAll('**', '').replaceAll('*', '');
  }

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
    _correlationAnalysis = CorrelationService.getCorrelationAnalysis(
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
      correlationAnalysis: _correlationAnalysis,
    );
    MemoryHistoryService.saveMeasurement(record);
  }

  void _goToHome() {
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

  void _goToCorrelation() {
    final String cleanCorrelation = _cleanText(_correlationAnalysis);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 40,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '🔬 Correlación de factores con tu FC',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    cleanCorrelation,
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = widget.heartRate < 60
        ? Colors.orange
        : (widget.heartRate > 100 ? Colors.red : Colors.green);
    final String statusText = widget.heartRate < 60
        ? 'Bradicardia'
        : (widget.heartRate > 100 ? 'Taquicardia' : 'Normal');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Resultado', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  size: 70,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${widget.heartRate}',
                style: const TextStyle(
                  fontSize: 56,
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
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _goToCorrelation,
                  icon: const Icon(Icons.analytics),
                  label: const Text(
                    'Factores de riesgo y su correlación',
                    style: TextStyle(fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Recomendación personalizada',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
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
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Comparar con tu grupo etario',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _saveMeasurement();
                        _goToHome();
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _goToHome,
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Salir'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


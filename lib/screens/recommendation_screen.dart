// lib/screens/recommendation_screen.dart
// VERSIÓN CON TARJETAS SEPARADAS POR SECCIÓN

import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  final int heartRate;
  final String recommendation;
  final int ageRange;
  final int gender;
  final List<int> conditions;
  final int symptoms;
  final int medications;

  const RecommendationScreen({
    super.key,
    required this.heartRate,
    required this.recommendation,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
  });

  String _getStatusText() {
    if (heartRate < 60) return 'Bradicardia - Ritmo lento';
    if (heartRate > 100) return 'Taquicardia - Ritmo rápido';
    return 'Normal - Ritmo saludable';
  }

  Color _getStatusColor() {
    if (heartRate < 60) return Colors.orange;
    if (heartRate > 100) return Colors.red;
    return Colors.green;
  }

  IconData _getStatusIcon() {
    if (heartRate < 60) return Icons.speed;
    if (heartRate > 100) return Icons.flash_on;
    return Icons.health_and_safety;
  }

  String _cleanText(String text) {
    return text.replaceAll('**', '').replaceAll('*', '');
  }

  List<Map<String, String>> _parseRecommendation() {
    String clean = _cleanText(recommendation);
    List<Map<String, String>> sections = [];
    
    List<String> parts = clean.split('\n\n');
    
    for (String part in parts) {
      if (part.trim().isEmpty) continue;
      
      String title = '';
      String content = part;
      
      if (part.contains(':')) {
        List<String> lines = part.split('\n');
        if (lines.isNotEmpty && lines[0].endsWith(':')) {
          title = lines[0].replaceAll(':', '');
          content = lines.skip(1).join('\n');
        }
      }
      
      sections.add({
        'title': title,
        'content': content.trim(),
      });
    }
    
    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final sections = _parseRecommendation();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recomendación', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
          child: Column(
            children: [
              // Tarjeta principal con FC y estado
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getStatusIcon(), size: 48, color: Colors.white),
                    ),
                    Text(
                      '$heartRate',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const Text(
                      'latidos por minuto',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Secciones separadas en tarjetas
              ...sections.map((section) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getCardColor(section['title'] ?? ''),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _getCardBorderColor(section['title'] ?? ''),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (section['title']!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              _getIconForTitle(section['title']!),
                              color: _getIconColor(section['title']!),
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                section['title']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getTitleColor(section['title']!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (section['title']!.isNotEmpty) const SizedBox(height: 12),
                      Text(
                        section['content']!,
                        style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),
              
              // Botón volver
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        ),
      ),
    );
  }

  Color _getCardColor(String title) {
    if (title.contains('ANÁLISIS') || title.contains('TU RITMO')) return Colors.red.shade50;
    if (title.contains('FACTORES') || title.contains('RIESGO')) return Colors.orange.shade50;
    if (title.contains('MEDICAMENTOS')) return Colors.blue.shade50;
    if (title.contains('RECOMENDACIONES')) return Colors.green.shade50;
    if (title.contains('MÉDICO')) return Colors.purple.shade50;
    if (title.contains('CONSEJOS')) return Colors.teal.shade50;
    return Colors.grey.shade50;
  }

  Color _getCardBorderColor(String title) {
    if (title.contains('ANÁLISIS') || title.contains('TU RITMO')) return Colors.red.shade200;
    if (title.contains('FACTORES') || title.contains('RIESGO')) return Colors.orange.shade200;
    if (title.contains('MEDICAMENTOS')) return Colors.blue.shade200;
    if (title.contains('RECOMENDACIONES')) return Colors.green.shade200;
    if (title.contains('MÉDICO')) return Colors.purple.shade200;
    if (title.contains('CONSEJOS')) return Colors.teal.shade200;
    return Colors.grey.shade200;
  }

  Color _getTitleColor(String title) {
    if (title.contains('ANÁLISIS') || title.contains('TU RITMO')) return Colors.red.shade700;
    if (title.contains('FACTORES') || title.contains('RIESGO')) return Colors.orange.shade700;
    if (title.contains('MEDICAMENTOS')) return Colors.blue.shade700;
    if (title.contains('RECOMENDACIONES')) return Colors.green.shade700;
    if (title.contains('MÉDICO')) return Colors.purple.shade700;
    if (title.contains('CONSEJOS')) return Colors.teal.shade700;
    return Colors.grey.shade700;
  }

  IconData _getIconForTitle(String title) {
    if (title.contains('ANÁLISIS') || title.contains('TU RITMO')) return Icons.favorite;
    if (title.contains('FACTORES') || title.contains('RIESGO')) return Icons.warning_amber;
    if (title.contains('MEDICAMENTOS')) return Icons.medical_services;
    if (title.contains('RECOMENDACIONES')) return Icons.lightbulb;
    if (title.contains('MÉDICO')) return Icons.local_hospital;
    if (title.contains('CONSEJOS')) return Icons.fitness_center;
    return Icons.info;
  }

  Color _getIconColor(String title) {
    if (title.contains('ANÁLISIS') || title.contains('TU RITMO')) return Colors.red;
    if (title.contains('FACTORES') || title.contains('RIESGO')) return Colors.orange;
    if (title.contains('MEDICAMENTOS')) return Colors.blue;
    if (title.contains('RECOMENDACIONES')) return Colors.green;
    if (title.contains('MÉDICO')) return Colors.purple;
    if (title.contains('CONSEJOS')) return Colors.teal;
    return Colors.grey;
  }
}

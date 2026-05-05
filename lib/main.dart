// lib/main.dart
// Punto de entrada principal de la aplicación

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  // Ejecuta la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor ECG',                    // Título de la app
      debugShowCheckedModeBanner: false,       // Oculta la etiqueta "DEBUG"
      theme: ThemeData(
        primarySwatch: Colors.red,             // Color principal (rojo para corazón)
        useMaterial3: true,                   // Usa Material Design 3
      ),
      home: const LoginScreen(),               // Pantalla que se muestra al abrir la app
    );
  }
}


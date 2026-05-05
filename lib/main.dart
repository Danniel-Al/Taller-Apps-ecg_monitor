// lib/main.dart
// PUNTO DE ENTRADA PRINCIPAL DE LA APLICACIÓN
// Este es el primer archivo que se ejecuta al iniciar la app

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  // Función principal que inicia la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // StatelessWidget = widget que no cambia su estado (estático)
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp = configuración principal de la app
    return MaterialApp(
      title: 'Monitor ECG',                    // Título visible en la app
      debugShowCheckedModeBanner: false,       // Oculta la etiqueta "DEBUG" en la esquina
      theme: ThemeData(
        primarySwatch: Colors.red,             // Color principal (rojo = corazón)
        useMaterial3: true,                   // Usa la versión más reciente de Material Design
      ),
      home: const LoginScreen(),               // Pantalla que se muestra al abrir la app
    );
  }
}


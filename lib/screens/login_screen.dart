// lib/screens/login_screen.dart
// PANTALLA DE INICIO DE SESIÓN
// Permite al usuario autenticarse para entrar a la aplicación

import 'package:flutter/material.dart';
import 'register_screen.dart';  // Importa la pantalla de registro para navegar

class LoginScreen extends StatefulWidget {
  // StatefulWidget = widget que PUEDE cambiar su estado (ej: mostrar errores)
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores: permiten leer el texto que el usuario escribe en los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función que se ejecuta al presionar el botón "Iniciar sesión"
  void _handleLogin() {
    // trim() elimina espacios en blanco al inicio y final
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    // Validación básica: ambos campos deben tener contenido
    if (username.isEmpty || password.isEmpty) {
      _showError('Por favor ingresa usuario y contraseña');
    } else {
      // Por ahora solo muestra un mensaje de bienvenida
      // En el futuro: validará contra usuarios registrados y navegará a Home
      _showSuccess('Bienvenido $username');
    }
  }

  // Muestra un mensaje de error (fondo rojo)
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Muestra un mensaje de éxito (fondo verde)
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold = estructura básica de una pantalla (barra superior, cuerpo, etc.)
    return Scaffold(
      body: Padding(
        // Padding = margen interior de 24 píxeles en todos los lados
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Column = organiza los widgets en vertical (uno debajo del otro)
          mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
          children: [
            // ========== ICONO PRINCIPAL ==========
            const Icon(Icons.favorite, size: 80, color: Colors.red),
            const SizedBox(height: 20),  // Espacio vertical

            // ========== TÍTULO ==========
            const Text(
              'Monitor ECG',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // ========== CAMPO: USUARIO ==========
            TextField(
              controller: _usernameController,  // Conecta con el controlador
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',  // Etiqueta flotante
                border: OutlineInputBorder(),    // Borde redondeado
                prefixIcon: Icon(Icons.person),  // Ícono a la izquierda
              ),
            ),
            const SizedBox(height: 16),

            // ========== CAMPO: CONTRASEÑA ==========
            TextField(
              controller: _passwordController,
              obscureText: true,  // Oculta el texto (muestra puntos ●●●)
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            // ========== BOTÓN: INICIAR SESIÓN ==========
            ElevatedButton(
              onPressed: _handleLogin,  // Función al hacer clic
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),  // Ancho completo, alto 50
                backgroundColor: Colors.red,  // Fondo rojo
              ),
              child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // ========== BOTÓN: IR A REGISTRO ==========
            TextButton(
              onPressed: () {
                // Navega a la pantalla de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}

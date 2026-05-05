// lib/screens/login_screen.dart
// Pantalla de inicio de sesión

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para leer el texto de los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función que se ejecuta al presionar el botón "Iniciar sesión"
  void _handleLogin() {
    final username = _usernameController.text.trim();  // Elimina espacios al inicio/final
    final password = _passwordController.text;

    // Validación: ambos campos deben tener contenido
    if (username.isEmpty || password.isEmpty) {
      _showError('Por favor ingresa usuario y contraseña');
    } else {
      _showSuccess('Bienvenido $username');
      // TODO: En el futuro, aquí se navegará a la pantalla principal
    }
  }

  // Muestra un mensaje de error en rojo
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Muestra un mensaje de éxito en verde
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),  // Margen interior de 24 pixeles
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centra verticalmente
          children: [
            // Icono de corazón rojo
            const Icon(Icons.favorite, size: 80, color: Colors.red),
            const SizedBox(height: 20),

            // Título de la app
            const Text('Monitor ECG', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            // Campo de texto: Usuario
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // Campo de texto: Contraseña (oculta el texto)
            TextField(
              controller: _passwordController,
              obscureText: true,  // Los caracteres se ven como puntos
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            // Botón de inicio de sesión
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),  // Ancho completo
                backgroundColor: Colors.red,
              ),
              child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),

            // Botón para ir al registro (aún sin funcionalidad)
            TextButton(
              onPressed: () {
                // TODO: Navegar a pantalla de registro (próximo paso)
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }
}

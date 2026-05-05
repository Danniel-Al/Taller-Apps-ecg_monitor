// lib/screens/register_screen.dart
// PANTALLA DE REGISTRO DE NUEVOS USUARIOS
// Permite crear una nueva cuenta con validaciones

import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para cada campo de texto
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  // Función que se ejecuta al presionar "Registrarse"
  void _handleRegister() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    // ========== VALIDACIONES ==========
    if (username.isEmpty) {
      _showError('Ingresa un nombre de usuario');
    } else if (password.isEmpty) {
      _showError('Ingresa una contraseña');
    } else if (password != confirm) {
      _showError('Las contraseñas no coinciden');  // Validación más importante
    } else if (password.length < 4) {
      _showError('La contraseña debe tener al menos 4 caracteres');
    } else {
      // TODO: Aquí se guardará el usuario (SharedPreferences o base de datos)
      _showSuccess('Registro exitoso. Ahora inicia sesión.');
      
      // Regresa automáticamente a la pantalla de login después de 2 segundos
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);  // Cierra la pantalla actual (vuelve al login)
      });
    }
  }

  // Muestra error en rojo
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Muestra éxito en verde
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar = barra superior con título y flecha de retroceso
      appBar: AppBar(
        title: const Text('Registro'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),  // Flecha para volver manualmente
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ========== ICONO DE PERSONA ==========
            const Icon(Icons.person_add, size: 60, color: Colors.red),
            const SizedBox(height: 20),

            // ========== TÍTULO ==========
            const Text(
              'Crea tu cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // ========== CAMPO: USUARIO ==========
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),

            // ========== CAMPO: CONTRASEÑA ==========
            TextField(
              controller: _passwordController,
              obscureText: true,  // Oculta con puntos
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),

            // ========== CAMPO: CONFIRMAR CONTRASEÑA ==========
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 24),

            // ========== BOTÓN: REGISTRARSE ==========
            ElevatedButton(
              onPressed: _handleRegister,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.red,
              ),
              child: const Text('Registrarse', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}


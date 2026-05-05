// lib/screens/home_screen.dart
// PANTALLA PRINCIPAL CON PESTAÑAS (BOTTOM NAVIGATION BAR)
// Pestaña 1: Tomar medición
// Pestaña 2: Perfil

import 'package:flutter/material.dart';
import 'measurement_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;  // 0: Medición, 1: Perfil

  // Lista de pantallas para cada pestaña
  final List<Widget> _screens = [
    const MeasurementScreen(),   // Pestaña de medición
    const ProfileScreen(),       // Pestaña de perfil (la crearemos después)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Tomar medición',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}


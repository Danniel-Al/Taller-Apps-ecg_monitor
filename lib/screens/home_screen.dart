// lib/screens/home_screen.dart
// PANTALLA PRINCIPAL CON PESTAÑAS (BOTTOM NAVIGATION BAR)

import 'package:flutter/material.dart';
import 'measurement_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final int ageRange;
  final int gender;
  final int conditions;
  final int symptoms;
  final int medications;

  const HomeScreen({
    super.key,
    required this.username,
    required this.ageRange,
    required this.gender,
    required this.conditions,
    required this.symptoms,
    required this.medications,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      // Pasar todos los datos demográficos a MeasurementScreen
      MeasurementScreen(
        ageRange: widget.ageRange,
        gender: widget.gender,
        conditions: widget.conditions,
        symptoms: widget.symptoms,
        medications: widget.medications,
      ),
      ProfileScreen(username: widget.username),
    ];
  }

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

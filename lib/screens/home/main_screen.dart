import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../transport/transport_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    CategoriesScreen(),
    TransportScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Color(0xFF0D9488),
        unselectedItemColor: Colors.grey,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "الأقسام",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: "المواصلات",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "الإعدادات",
          ),
        ],
      ),
    );
  }
}
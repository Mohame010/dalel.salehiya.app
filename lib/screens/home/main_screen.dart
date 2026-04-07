import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../transport/transport_screen.dart';
import '../settings/settings_screen.dart';
import '../home/favorites_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final screens = [
    HomeScreen(),        // 0
    CategoriesScreen(),  // 1
    FavoritesScreen(),   // 2 ❤️
    TransportScreen(),   // 3
    SettingsScreen(),    // 4
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

        selectedItemColor: Color(0xFF03819B),
        unselectedItemColor: Colors.grey,

        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ), // 0

          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "الأقسام",
          ), // 1

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "المفضلة",
          ), // 2 ❤️

          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: "المواصلات",
          ), // 3

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "الإعدادات",
          ), // 4
        ],
      ),
    );
  }
}
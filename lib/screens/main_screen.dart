import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'latest_recipes_screen.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    LatestRecipesScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    ProfileScreen(),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Dernières'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Catégories'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        selectedFontSize: 15,
        selectedItemColor: Colors.orange[700],
        unselectedItemColor: Colors.black,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'history_screen.dart';

// StatefulWidget car on doit mémoriser et modifier l'onglet actif
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 1. On crée une variable pour stocker l'index (le numéro) de l'onglet actif.
  // En programmation, on commence à compter à 0. Donc 0 = le premier onglet.
  int _selectedIndex = 0;

  // 2. On liste les écrans qui correspondent à chaque onglet, dans l'ordre.
  final List<Widget> _screens = [
    const ProductListScreen(), // Index 0
    const FavoritesScreen(), // Index 1
    const CartScreen(), // Index 2
    const HistoryScreen(), // Index 3
  ];

  // 3. Cette fonction s'exécute quand tu cliques sur un bouton en bas
  void _onItemTapped(int index) {
    // setState est LA fonction magique des StatefulWidget.
    // Elle dit à Flutter : "Hé, une donnée a changé, redessine l'écran stp !"
    setState(() {
      _selectedIndex =
          index; // On met à jour notre variable avec le nouvel index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Le body affiche l'écran correspondant au numéro actuel
      body: _screens[_selectedIndex],

      // La fameuse barre de navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Fond blanc pur
        elevation: 8, // Une ombre légère pour détacher la barre
        selectedItemColor: Colors.black, // L'élément actif est noir profond
        unselectedItemColor: Colors.blue[400], // L'inactif est un gris discret
        showUnselectedLabels:
            true, // Affiche les labels pour garder une symétrie
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Produits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }
}

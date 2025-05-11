import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import 'dashboard_screen.dart';
import 'stock_screen.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'sales_screen.dart';
import 'profile_screen.dart';
import '../auth/login_screen.dart';

class PharmacistHomeScreen extends StatefulWidget {
  const PharmacistHomeScreen({Key? key}) : super(key: key);

  @override
  State<PharmacistHomeScreen> createState() => _PharmacistHomeScreenState();
}

class _PharmacistHomeScreenState extends State<PharmacistHomeScreen> {
  final List<Widget> _screens = [
    const DashboardScreen(),
    const StockScreen(),
    const CatalogScreen(),
    const CartScreen(),
    const SalesScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = [
    'Tableau de bord',
    'Mon Stock',
    'Catalogue',
    'Panier',
    'Ventes',
    'Profil',
  ];

  void _onItemTapped(int index) {
    Provider.of<AppState>(context, listen: false).setCurrentIndex(index);
  }

  void _logout() {
    Provider.of<AppState>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final _selectedIndex = appState.currentIndex;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          if (_selectedIndex == 2) // Uniquement pour l'écran Catalogue
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                // Fonctionnalité de partage
              },
              tooltip: 'Partager',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Ventes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}


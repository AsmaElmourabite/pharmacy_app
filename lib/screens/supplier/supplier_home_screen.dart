import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../auth/login_screen.dart';
import '../../utils/theme.dart';

class SupplierHomeScreen extends StatelessWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    void _logout() {
      appState.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Espace Fournisseur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.store,
              size: 80,
              color: AppTheme.pharmacyGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'Bienvenue, ${user?.firstName} ${user?.lastName}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Espace fournisseur en construction',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      ),
    );
  }
}


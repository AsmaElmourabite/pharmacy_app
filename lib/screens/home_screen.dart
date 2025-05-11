import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../utils/theme.dart';
import 'pharmacist/pharmacist_home_screen.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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

    void _navigateToFeature(int index) {
      if (user != null) {
        appState.setCurrentIndex(index);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PharmacistHomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez vous connecter pour accéder à cette fonctionnalité'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('PharmacieConnect'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'Déconnexion',
            ),
        ],
      ),
      body: Column(
        children: [
          // Barre verte avec avatar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppTheme.pharmacyGreen,
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user != null 
                        ? '${user.firstName} ${user.lastName}'
                        : 'Invité',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bannière de bienvenue
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Bienvenue sur PharmacieConnect',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'La solution complète pour connecter pharmaciens et fournisseurs',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (user == null)
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.pharmacyGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Se connecter'),
                          ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Titre des fonctionnalités
                  const Text(
                    'Nos fonctionnalités',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Grille de fonctionnalités
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      // Gestion de Stock
                      _buildFeatureCard(
                        title: 'Gestion de Stock',
                        icon: Icons.inventory,
                        iconColor: Colors.amber,
                        description: 'Suivez votre inventaire en temps réel',
                        onTap: () => _navigateToFeature(1),
                      ),
                      
                      // Commandes Simplifiées
                      _buildFeatureCard(
                        title: 'Commandes Simplifiées',
                        icon: Icons.shopping_cart,
                        iconColor: Colors.red,
                        description: 'Commandez auprès de vos fournisseurs',
                        onTap: () => _navigateToFeature(2),
                      ),
                      
                      // Tableau de bord
                      _buildFeatureCard(
                        title: 'Tableau de bord',
                        icon: Icons.dashboard,
                        iconColor: Colors.blue,
                        description: 'Visualisez vos statistiques clés',
                        onTap: () => _navigateToFeature(0),
                      ),
                      
                      // Suivi Des ventes
                      _buildFeatureCard(
                        title: 'Suivi Des ventes',
                        icon: Icons.bar_chart,
                        iconColor: Colors.purple,
                        description: 'Analysez vos performances de vente',
                        onTap: () => _navigateToFeature(4),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section À propos
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'À propos de PharmacieConnect',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'PharmacieConnect est une application conçue pour simplifier la gestion quotidienne des pharmacies et améliorer la communication avec les fournisseurs. Notre objectif est d\'optimiser votre flux de travail et d\'augmenter votre efficacité.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoItem(Icons.security, 'Sécurisé'),
                            _buildInfoItem(Icons.speed, 'Rapide'),
                            _buildInfoItem(Icons.devices, 'Multi-appareils'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Pied de page
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            color: Colors.grey.shade200,
            child: const Text(
              '© 2025 PharmacieConnect | Tous droits réservés',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconColor.withOpacity(0.2),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.pharmacyGreen,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

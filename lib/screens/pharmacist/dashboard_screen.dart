import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/medication.dart';
import '../../models/sale.dart';
import '../../services/mock_data_service.dart';
import '../../services/app_state.dart';
import '../../utils/theme.dart';
import 'stock_screen.dart';
import 'sales_screen.dart';
import 'catalog_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<Medication> _lowStockItems;
  late List<Sale> _recentSales;
  late double _totalSales;
  late int _totalProducts;
  late int _lowStockCount;
  late int _suppliersCount;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    // Récupérer les médicaments en stock faible (moins de 20 unités)
    _lowStockItems = MockDataService.pharmacyStock
        .where((medication) => medication.quantity < 20)
        .toList();
    
    // Récupérer les ventes récentes (toutes les ventes pour la démo)
    _recentSales = List.from(MockDataService.sales);
    
    // Calculer le total des ventes
    _totalSales = _recentSales.fold(
      0, (total, sale) => total + sale.total
    );
    
    // Compter le nombre total de produits
    _totalProducts = MockDataService.pharmacyStock.length;
    
    // Compter le nombre de produits en stock faible
    _lowStockCount = _lowStockItems.length;
    
    // Compter le nombre de fournisseurs
    _suppliersCount = MockDataService.users
        .where((user) => user.role.toString().contains('supplier'))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec salutation
          const Text(
            'Bonjour, Pharmacien',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            DateFormat('EEEE d MMMM yyyy').format(DateTime.now()),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Cartes de statistiques
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                title: 'Ventes totales',
                value: '${_totalSales.toStringAsFixed(2)} DHS',
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              _buildStatCard(
                title: 'Produits',
                value: '$_totalProducts',
                icon: Icons.medication,
                color: Colors.blue,
              ),
              _buildStatCard(
                title: 'Stock faible',
                value: '$_lowStockCount',
                icon: Icons.warning_amber,
                color: Colors.orange,
              ),
              _buildStatCard(
                title: 'Fournisseurs',
                value: '$_suppliersCount',
                icon: Icons.people,
                color: Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Graphique des ventes (simulé avec un conteneur coloré)
          const Text(
            'Aperçu des ventes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              painter: ChartPainter(),
              child: const Center(
                child: Text(
                  'Graphique des ventes',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Accès rapides
          const Text(
            'Accès rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickAccessButton(
                icon: Icons.inventory,
                label: 'Stock',
                onTap: () => _navigateTo(context, 0),
              ),
              _buildQuickAccessButton(
                icon: Icons.shopping_bag,
                label: 'Catalogue',
                onTap: () => _navigateTo(context, 1),
              ),
              _buildQuickAccessButton(
                icon: Icons.receipt_long,
                label: 'Ventes',
                onTap: () => _navigateTo(context, 3),
              ),
              _buildQuickAccessButton(
                icon: Icons.add_circle,
                label: 'Ajouter',
                onTap: () {
                  // Naviguer vers l'écran d'ajout de médicament
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StockScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Produits en stock faible
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stock faible',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _navigateTo(context, 0),
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _lowStockItems.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Aucun produit en stock faible'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _lowStockItems.length > 3 ? 3 : _lowStockItems.length,
                  itemBuilder: (context, index) {
                    final medication = _lowStockItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.medication,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          medication.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Quantité: ${medication.quantity}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Naviguer vers l'écran de stock
                            _navigateTo(context, 0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.pharmacyGreen,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Commander'),
                        ),
                      ),
                    );
                  },
                ),
          
          const SizedBox(height: 24),
          
          // Ventes récentes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ventes récentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => _navigateTo(context, 3),
                child: const Text('Voir tout'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _recentSales.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Aucune vente récente'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentSales.length > 3 ? 3 : _recentSales.length,
                  itemBuilder: (context, index) {
                    final sale = _recentSales[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.receipt,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(
                          sale.medicationName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Date: ${DateFormat('dd/MM/yyyy').format(sale.date)}',
                        ),
                        trailing: Text(
                          '${sale.total.toStringAsFixed(2)} DHS',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.pharmacyGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.pharmacyGreen,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, int index) {
    // Utiliser Provider pour changer l'index de navigation
    Provider.of<AppState>(context, listen: false).setCurrentIndex(index);
  }
}

// Peintre personnalisé pour simuler un graphique
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.pharmacyGreen
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    
    // Points du graphique (simulés)
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.2),
    ];
    
    // Dessiner la ligne
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    canvas.drawPath(path, paint);
    
    // Dessiner les points
    final pointPaint = Paint()
      ..color = AppTheme.pharmacyGreen
      ..style = PaintingStyle.fill;
    
    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
    }
    
    // Dessiner la zone sous la courbe
    final fillPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    
    final fillPaint = Paint()
      ..color = AppTheme.pharmacyGreen.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

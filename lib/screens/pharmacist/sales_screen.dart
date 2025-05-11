import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/sale.dart';
import '../../services/mock_data_service.dart';
import 'add_sale_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Sale> _sales;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _sales = List.from(MockDataService.sales);

    // Ajouter un écouteur pour les changements d'onglet
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});  // Forcer la mise à jour de l'interface
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addSale() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSaleScreen(),
      ),
    );

    if (result != null && result is Sale) {
      setState(() {
        _sales.add(result);
      });
    }
  }

  // Méthode pour obtenir le style du texte des onglets
  TextStyle _getTabTextStyle(int index) {
    return TextStyle(
      fontSize: _tabController.index == index ? 16 : 14,
      fontWeight: _tabController.index == index ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  'Historique',
                  style: _getTabTextStyle(0),
                ),
              ),
              Tab(
                child: Text(
                  'Déclarer',
                  style: _getTabTextStyle(1),
                ),
              ),
            ],
            // Ajouter ces propriétés pour personnaliser les couleurs
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            // Ajouter un décorateur pour personnaliser l'apparence des onglets
            indicator: BoxDecoration(
              color: Colors.green.shade800,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Sales History Tab
          _sales.isEmpty
              ? const Center(
                  child: Text('Aucune vente enregistrée'),
                )
              : ListView.builder(
                  itemCount: _sales.length,
                  itemBuilder: (context, index) {
                    final sale = _sales[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          sale.medicationName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quantité: ${sale.quantity} • Prix: ${sale.price.toStringAsFixed(2)} €',
                            ),
                            Text(
                              'Date: ${DateFormat('dd/MM/yyyy').format(sale.date)}',
                            ),
                          ],
                        ),
                        trailing: Text(
                          '${sale.total.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          
          // Add Sale Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Déclarer une nouvelle vente',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Utilisez le bouton ci-dessous pour déclarer une nouvelle vente de médicament.',
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addSale,
                    icon: const Icon(Icons.add),
                    label: const Text('Déclarer une vente'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


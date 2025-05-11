import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medication.dart';
import '../../models/user.dart';
import '../../services/mock_data_service.dart';
import '../../services/app_state.dart';
import 'medication_detail_screen.dart';

class SupplierDetailScreen extends StatelessWidget {
  final String supplierId;

  const SupplierDetailScreen({
    Key? key,
    required this.supplierId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplier = MockDataService.getSupplierById(supplierId);
    final medications = MockDataService.getMedicationsBySupplier(supplierId);

    return Scaffold(
      appBar: AppBar(
        title: Text('${supplier.firstName} ${supplier.lastName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations du fournisseur',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Nom', '${supplier.firstName} ${supplier.lastName}'),
                    _buildInfoRow('Email', supplier.email),
                    _buildInfoRow('Téléphone', supplier.phoneNumber),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Médicaments disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            medications.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('Aucun médicament disponible'),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final medication = medications[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            medication.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Prix: ${medication.price.toStringAsFixed(2)} € • Quantité: ${medication.quantity}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
                              final appState = Provider.of<AppState>(context, listen: false);
                              appState.addToCart(medication);
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${medication.name} ajouté au panier'),
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicationDetailScreen(
                                  medication: medication,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

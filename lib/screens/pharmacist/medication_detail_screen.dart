import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/medication.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({
    Key? key,
    required this.medication,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medication.name),
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
                      'Informations du médicament',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow('Nom', medication.name),
                    _buildInfoRow('Description', medication.description),
                    _buildInfoRow(
                      'Prix unitaire',
                      '${medication.price.toStringAsFixed(2)} DHS',
                    ),
                    _buildInfoRow('Quantité en stock', medication.quantity.toString()),
                    _buildInfoRow(
                      'Date d\'expiration',
                      DateFormat('dd/MM/yyyy').format(medication.expiryDate),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (medication.supplierId != null) ...[
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
                      _buildInfoRow('Nom', medication.supplierName ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ],
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
            width: 120,
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

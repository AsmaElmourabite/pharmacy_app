import 'package:flutter/material.dart';
import '../../models/medication.dart';
import '../../services/mock_data_service.dart';
import 'add_medication_screen.dart';
import 'medication_detail_screen.dart';
import '../../utils/theme.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late List<Medication> _medications;
  late List<Medication> _filteredMedications;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medications = List.from(MockDataService.pharmacyStock);
    _filteredMedications = List.from(_medications);
    _searchController.addListener(_filterMedications);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMedications() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedications = _medications
          .where((medication) => medication.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void _addMedication() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicationScreen(),
      ),
    );

    if (result != null && result is Medication) {
      setState(() {
        _medications.add(result);
        _filterMedications();
      });
      
      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.name} ajouté avec succès'),
          backgroundColor: AppTheme.pharmacyGreen,
        ),
      );
    }
  }

  void _editMedication(Medication medication) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicationScreen(medication: medication),
      ),
    );

    if (result != null && result is Medication) {
      setState(() {
        final index = _medications.indexWhere((m) => m.id == medication.id);
        if (index >= 0) {
          _medications[index] = result;
          _filterMedications();
        }
      });
      
      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${result.name} mis à jour avec succès'),
          backgroundColor: AppTheme.pharmacyGreen,
        ),
      );
    }
  }

  void _deleteMedication(Medication medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer ${medication.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _medications.removeWhere((m) => m.id == medication.id);
                _filterMedications();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${medication.name} supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Supprimer'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un médicament...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _filteredMedications.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun médicament trouvé',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredMedications.length,
                    itemBuilder: (context, index) {
                      final medication = _filteredMedications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(
                            medication.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Quantité: ${medication.quantity} • Prix: ${medication.price.toStringAsFixed(2)} DHS',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppTheme.pharmacyGreen),
                                onPressed: () => _editMedication(medication),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteMedication(medication),
                              ),
                            ],
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedication,
        child: const Icon(Icons.add),
        tooltip: 'Ajouter un médicament',
      ),
    );
  }
}


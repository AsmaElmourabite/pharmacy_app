import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medication.dart';
import '../../models/user.dart';
import '../../services/mock_data_service.dart';
import '../../services/app_state.dart';
import 'medication_detail_screen.dart';
import '../../utils/theme.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late List<Medication> _medications;
  late List<Medication> _filteredMedications;
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSupplierId;
  int _currentPage = 0;
  final int _itemsPerPage = 4;
  bool _isSorted = false;

  @override
  void initState() {
    super.initState();
    _medications = List.from(MockDataService.medications);
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
          .where((medication) {
            final nameMatch = medication.name.toLowerCase().contains(query);
            final supplierMatch = _selectedSupplierId == null || 
                                 medication.supplierId == _selectedSupplierId;
            return nameMatch && supplierMatch;
          })
          .toList();
      _currentPage = 0; // Reset to first page when filtering
    });
  }

  void _selectSupplier(String? supplierId) {
    setState(() {
      _selectedSupplierId = supplierId;
      _filterMedications();
    });
  }

  void _sortMedications() {
    setState(() {
      if (_isSorted) {
        // Annuler le tri - revenir à l'ordre original
        _filteredMedications = List.from(_medications.where((medication) {
          final supplierMatch = _selectedSupplierId == null || 
                               medication.supplierId == _selectedSupplierId;
          return supplierMatch;
        }));
        
        // Appliquer le filtre de recherche si nécessaire
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          _filteredMedications = _filteredMedications
              .where((medication) => medication.name.toLowerCase().contains(query))
              .toList();
        }
        
        _isSorted = false;
      } else {
        // Trier par prix croissant
        _filteredMedications.sort((a, b) => a.price.compareTo(b.price));
        _isSorted = true;
      }
      _currentPage = 0; // Reset to first page when sorting
    });
  }

  void _addToCart(Medication medication) {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.addToCart(medication);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medication.name} ajouté au panier'),
        backgroundColor: AppTheme.pharmacyGreen,
        action: SnackBarAction(
          label: 'Voir panier',
          textColor: Colors.white,
          onPressed: () {
            appState.setCurrentIndex(3); // Ajuster l'index selon votre navigation
          },
        ),
      ),
    );
  }

  int get _pageCount {
    return (_filteredMedications.length / _itemsPerPage).ceil();
  }

  List<Medication> get _paginatedMedications {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage > _filteredMedications.length 
        ? _filteredMedications.length 
        : startIndex + _itemsPerPage;
    
    if (startIndex >= _filteredMedications.length) {
      return [];
    }
    
    return _filteredMedications.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un médicament...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isSorted ? Icons.sort : Icons.sort,
                        color: _isSorted ? AppTheme.pharmacyGreen : Colors.grey,
                      ),
                      tooltip: _isSorted ? 'Annuler le tri' : 'Trier par prix',
                      onPressed: _sortMedications,
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Supplier filter dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isSorted)
                TextButton.icon(
                  onPressed: _sortMedications,
                  icon: const Icon(Icons.cancel, size: 18),
                  label: const Text('Annuler le tri'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                )
              else
                const SizedBox(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _selectedSupplierId,
                    hint: const Text('Tous les fournisseurs'),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    onChanged: (String? newValue) {
                      _selectSupplier(newValue);
                    },
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('Tous les fournisseurs'),
                      ),
                      ...MockDataService.users
                          .where((user) => user.role == UserRole.supplier)
                          .map((supplier) {
                        return DropdownMenuItem<String>(
                          value: supplier.id,
                          child: Text('${supplier.firstName} ${supplier.lastName}'),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Medications grid
        Expanded(
          child: _filteredMedications.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun médicament trouvé',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _paginatedMedications.length,
                  itemBuilder: (context, index) {
                    final medication = _paginatedMedications[index];
                    final supplier = MockDataService.getSupplierById(
                      medication.supplierId ?? '0',
                    );
                    
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Medication image
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                child: Center(
                                  child: getMedicationIcon(medication.name),
                                ),
                              ),
                            ),
                            
                            // Medication info
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    medication.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Fournisseur: ${supplier.firstName}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${medication.price.toStringAsFixed(2)} DHS',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () => _addToCart(medication),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.pharmacyGreen,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: const Text(
                                        'Ajouter au panier',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        
        // Pagination
        if (_pageCount > 1)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _pageCount; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPage = i;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? AppTheme.pharmacyGreen : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: _currentPage == i ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_currentPage < _pageCount - 1)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPage++;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Suivant >>',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget getMedicationIcon(String name) {
    // Utiliser l'image locale pour Doliprane
    if (name.toLowerCase().contains('doliprane')) {
      return Image.asset(
        'assets/images/doliprane.png',
        width: 100,
        height: 100,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('Erreur de chargement de l\'image: $error');
          // Fallback en cas d'erreur
          return Icon(
            Icons.medication,
            size: 60,
            color: Colors.blue,
          );
        },
      );
    }
    
    // Pour les autres médicaments, utiliser des icônes colorées
    IconData iconData;
    Color iconColor;
    
    if (name.toLowerCase().contains('aspirine')) {
      iconData = Icons.medication;
      iconColor = Colors.orange;
    } else if (name.toLowerCase().contains('dafalgan')) {
      iconData = Icons.medication;
      iconColor = Colors.red;
    } else if (name.toLowerCase().contains('valium')) {
      iconData = Icons.medication;
      iconColor = Colors.purple;
    } else if (name.toLowerCase().contains('oméprazole')) {
      iconData = Icons.medication;
      iconColor = Colors.green;
    } else if (name.toLowerCase().contains('amoxicilline')) {
      iconData = Icons.medication;
      iconColor = Colors.pink;
    } else if (name.toLowerCase().contains('spasfon')) {
      iconData = Icons.medication;
      iconColor = Colors.teal;
    } else if (name.toLowerCase().contains('smecta')) {
      iconData = Icons.medication;
      iconColor = Colors.amber;
    } else {
      iconData = Icons.medication;
      iconColor = Colors.grey;
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 60,
          color: iconColor,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            name.split(' ')[0], // Afficher seulement le premier mot du nom
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}



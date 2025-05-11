import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/medication.dart';
import '../../models/sale.dart';
import '../../services/mock_data_service.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({Key? key}) : super(key: key);

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  Medication? _selectedMedication;
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _saleDate = DateTime.now();

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _saleDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _saleDate) {
      setState(() {
        _saleDate = picked;
      });
    }
  }

  void _saveSale() {
    if (_formKey.currentState!.validate() && _selectedMedication != null) {
      final sale = Sale(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicationId: _selectedMedication!.id,
        medicationName: _selectedMedication!.name,
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
        date: _saleDate,
      );

      Navigator.pop(context, sale);
    }
  }

  @override
  Widget build(BuildContext context) {
    final medications = [...MockDataService.pharmacyStock];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Déclarer une vente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<Medication>(
                decoration: const InputDecoration(
                  labelText: 'Médicament',
                ),
                value: _selectedMedication,
                items: medications.map((medication) {
                  return DropdownMenuItem<Medication>(
                    value: medication,
                    child: Text(medication.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMedication = value;
                    if (value != null) {
                      _priceController.text = value.price.toString();
                    }
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un médicament';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantité vendue',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une quantité';
                  }
                  try {
                    final quantity = int.parse(value);
                    if (quantity <= 0) {
                      return 'La quantité doit être supérieure à 0';
                    }
                    if (_selectedMedication != null && quantity > _selectedMedication!.quantity) {
                      return 'Quantité insuffisante en stock';
                    }
                  } catch (e) {
                    return 'Veuillez entrer un nombre entier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Prix unitaire (DHS)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prix';
                  }
                  try {
                    final price = double.parse(value);
                    if (price <= 0) {
                      return 'Le prix doit être supérieur à 0';
                    }
                  } catch (e) {
                    return 'Veuillez entrer un nombre valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Date de vente:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy').format(_saleDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveSale,
                  child: const Text('Enregistrer la vente'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

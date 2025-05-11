import '../models/medication.dart';
import '../models/user.dart';
import '../models/sale.dart';

class MockDataService {
  // Mock users
  static final List<User> users = [
    User(
      id: '1',
      firstName: 'Jean',
      lastName: 'Dupont',
      email: 'jean@example.com',
      phoneNumber: '0123456789',
      role: UserRole.pharmacist,
    ),
    User(
      id: '2',
      firstName: 'Marie',
      lastName: 'Martin',
      email: 'marie@example.com',
      phoneNumber: '0987654321',
      role: UserRole.supplier,
    ),
    User(
      id: '3',
      firstName: 'Pierre',
      lastName: 'Bernard',
      email: 'pierre@example.com',
      phoneNumber: '0567891234',
      role: UserRole.supplier,
    ),
    User(
      id: '4',
      firstName: 'Jake',
      lastName: 'Pharma',
      email: 'jake@example.com',
      phoneNumber: '0567891235',
      role: UserRole.supplier,
    ),
    User(
      id: '5',
      firstName: 'Hind',
      lastName: 'Pharma',
      email: 'hind@example.com',
      phoneNumber: '0567891236',
      role: UserRole.supplier,
    ),
    User(
      id: '6',
      firstName: 'Simon',
      lastName: 'Pharma',
      email: 'simon@example.com',
      phoneNumber: '0567891237',
      role: UserRole.supplier,
    ),
    User(
      id: '7',
      firstName: 'Anna',
      lastName: 'Pharma',
      email: 'anna@example.com',
      phoneNumber: '0567891238',
      role: UserRole.supplier,
    ),
  ];

  // Mock medications
  static final List<Medication> medications = [
    Medication(
      id: '1',
      name: 'Aspirine 500mg',
      description: 'Analgésique et antipyrétique',
      price: 16.70,
      quantity: 100,
      expiryDate: DateTime(2024, 12, 31),
      supplierId: '4',
      supplierName: 'Jake Pharma',
    ),
    Medication(
      id: '2',
      name: 'Doliprane 1000mg',
      description: 'Paracétamol 1000mg',
      price: 13.90,
      quantity: 50,
      expiryDate: DateTime(2025, 6, 30),
      supplierId: '5',
      supplierName: 'Hind Pharma',
    ),
    Medication(
      id: '3',
      name: 'Dafalgan 500mg',
      description: 'Paracétamol 500mg',
      price: 13.90,
      quantity: 30,
      expiryDate: DateTime(2024, 10, 15),
      supplierId: '6',
      supplierName: 'Simon Pharma',
    ),
    Medication(
      id: '4',
      name: 'Valium 5mg',
      description: 'Diazépam 5mg',
      price: 16.70,
      quantity: 80,
      expiryDate: DateTime(2025, 3, 20),
      supplierId: '7',
      supplierName: 'Anna Pharma',
    ),
    Medication(
      id: '5',
      name: 'Oméprazole 20mg',
      description: 'Inhibiteur de la pompe à protons',
      price: 15.75,
      quantity: 20,
      expiryDate: DateTime(2024, 8, 10),
      supplierId: '2',
      supplierName: 'Marie Martin',
    ),
    Medication(
      id: '6',
      name: 'Amoxicilline 500mg',
      description: 'Antibiotique',
      price: 18.50,
      quantity: 40,
      expiryDate: DateTime(2024, 9, 15),
      supplierId: '3',
      supplierName: 'Pierre Bernard',
    ),
    Medication(
      id: '7',
      name: 'Spasfon Lyoc',
      description: 'Antispasmodique',
      price: 12.30,
      quantity: 60,
      expiryDate: DateTime(2025, 2, 28),
      supplierId: '4',
      supplierName: 'Jake Pharma',
    ),
    Medication(
      id: '8',
      name: 'Smecta',
      description: 'Anti-diarrhéique',
      price: 9.80,
      quantity: 30,
      expiryDate: DateTime(2025, 4, 10),
      supplierId: '5',
      supplierName: 'Hind Pharma',
    ),
  ];

  // Mock pharmacy stock
  static final List<Medication> pharmacyStock = [
    Medication(
      id: '6',
      name: 'Doliprane',
      description: 'Paracétamol 1000mg',
      price: 6.50 * 2, // Prix en DHS
      quantity: 45,
      expiryDate: DateTime(2025, 5, 15),
    ),
    Medication(
      id: '7',
      name: 'Advil',
      description: 'Ibuprofène 400mg',
      price: 8.25 * 2, // Prix en DHS
      quantity: 30,
      expiryDate: DateTime(2024, 11, 20),
    ),
  ];

  // Mock sales
  static final List<Sale> sales = [
    Sale(
      id: '1',
      medicationId: '6',
      medicationName: 'Doliprane',
      quantity: 2,
      price: 6.50 * 2, // Prix en DHS
      date: DateTime(2023, 10, 15),
    ),
    Sale(
      id: '2',
      medicationId: '7',
      medicationName: 'Advil',
      quantity: 1,
      price: 8.25 * 2, // Prix en DHS
      date: DateTime(2023, 10, 16),
    ),
  ];

  // Get supplier by ID
  static User getSupplierById(String id) {
    return users.firstWhere(
      (user) => user.id == id && user.role == UserRole.supplier,
      orElse: () => User(
        id: '0',
        firstName: 'Unknown',
        lastName: 'Supplier',
        email: 'unknown@example.com',
        phoneNumber: '0000000000',
        role: UserRole.supplier,
      ),
    );
  }

  // Get medications by supplier ID
  static List<Medication> getMedicationsBySupplier(String supplierId) {
    return medications
        .where((medication) => medication.supplierId == supplierId)
        .toList();
  }
}

class Medication {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final DateTime expiryDate;
  final String? supplierId;
  final String? supplierName;

  Medication({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    this.supplierId,
    this.supplierName,
  });
}

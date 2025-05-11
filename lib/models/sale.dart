class Sale {
  final String id;
  final String medicationId;
  final String medicationName;
  final int quantity;
  final double price;
  final DateTime date;

  Sale({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.quantity,
    required this.price,
    required this.date,
  });

  double get total => price * quantity;
}

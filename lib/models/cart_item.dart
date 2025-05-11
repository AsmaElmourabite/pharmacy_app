import 'medication.dart';

class CartItem {
  final Medication medication;
  int quantity;

  CartItem({
    required this.medication,
    this.quantity = 1,
  });

  double get total => medication.price * quantity;
}

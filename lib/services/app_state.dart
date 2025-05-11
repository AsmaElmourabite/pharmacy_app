import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/medication.dart';
import '../models/cart_item.dart';

class AppState extends ChangeNotifier {
  User? currentUser;
  final Map<String, List<CartItem>> carts = {}; // supplierId -> cart items
  
  // Ajouter cette propriété pour gérer l'index de navigation
  int _currentIndex = 0;
  
  // Getter pour l'index actuel
  int get currentIndex => _currentIndex;
  
  // Méthode pour définir l'index
  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void login(User user) {
    currentUser = user;
    notifyListeners();
  }

  void logout() {
    currentUser = null;
    carts.clear();
    notifyListeners();
  }

  void addToCart(Medication medication) {
    if (medication.supplierId == null) return;
    
    if (!carts.containsKey(medication.supplierId)) {
      carts[medication.supplierId!] = [];
    }
    
    final existingItemIndex = carts[medication.supplierId!]!.indexWhere(
      (item) => item.medication.id == medication.id
    );
    
    if (existingItemIndex >= 0) {
      carts[medication.supplierId!]![existingItemIndex].quantity++;
    } else {
      carts[medication.supplierId!]!.add(CartItem(medication: medication));
    }
    
    notifyListeners();
  }

  void updateCartItemQuantity(String supplierId, String medicationId, int quantity) {
    if (!carts.containsKey(supplierId)) return;
    
    final index = carts[supplierId]!.indexWhere(
      (item) => item.medication.id == medicationId
    );
    
    if (index >= 0) {
      if (quantity <= 0) {
        carts[supplierId]!.removeAt(index);
      } else {
        carts[supplierId]![index].quantity = quantity;
      }
      
      notifyListeners();
    }
  }

  void removeFromCart(String supplierId, String medicationId) {
    if (!carts.containsKey(supplierId)) return;
    
    carts[supplierId]!.removeWhere(
      (item) => item.medication.id == medicationId
    );
    
    if (carts[supplierId]!.isEmpty) {
      carts.remove(supplierId);
    }
    
    notifyListeners();
  }

  void clearCart(String supplierId) {
    carts.remove(supplierId);
    notifyListeners();
  }

  List<CartItem> getCartItems(String supplierId) {
    return carts[supplierId] ?? [];
  }

  double getCartTotal(String supplierId) {
    if (!carts.containsKey(supplierId)) return 0;
    
    return carts[supplierId]!.fold(
      0, (total, item) => total + item.total
    );
  }

  bool hasItems() {
    return carts.isNotEmpty;
  }

  List<String> getSupplierIdsWithCarts() {
    return carts.keys.toList();
  }
}

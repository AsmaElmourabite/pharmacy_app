import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../services/mock_data_service.dart';
import '../../utils/theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final supplierIds = appState.getSupplierIdsWithCarts();
        
        if (supplierIds.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Votre panier est vide',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ajoutez des médicaments depuis le catalogue',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          itemCount: supplierIds.length,
          itemBuilder: (context, index) {
            final supplierId = supplierIds[index];
            final supplier = MockDataService.getSupplierById(supplierId);
            final cartItems = appState.getCartItems(supplierId);
            final total = appState.getCartTotal(supplierId);
            
            return Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: AppTheme.pharmacyGreen),
                        const SizedBox(width: 8),
                        Text(
                          'Fournisseur: ${supplier.firstName} ${supplier.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, itemIndex) {
                      final item = cartItems[itemIndex];
                      return ListTile(
                        title: Text(item.medication.name),
                        subtitle: Text(
                          'Prix unitaire: ${item.medication.price.toStringAsFixed(2)} DHS',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.grey),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  appState.updateCartItemQuantity(
                                    supplierId,
                                    item.medication.id,
                                    item.quantity - 1,
                                  );
                                } else {
                                  appState.removeFromCart(
                                    supplierId,
                                    item.medication.id,
                                  );
                                }
                              },
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: AppTheme.pharmacyGreen),
                              onPressed: () {
                                appState.updateCartItemQuantity(
                                  supplierId,
                                  item.medication.id,
                                  item.quantity + 1,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                appState.removeFromCart(
                                  supplierId,
                                  item.medication.id,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${total.toStringAsFixed(2)} DHS',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.pharmacyGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  appState.clearCart(supplierId);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Vider le panier'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Vider le panier après avoir passé la commande
                                    appState.clearCart(supplierId);
                                    
                                    // Afficher un message de confirmation
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Commande passée avec succès! Votre panier a été vidé.'),
                                        backgroundColor: AppTheme.pharmacyGreen,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                    
                                    // Forcer la mise à jour de l'interface utilisateur
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      if (context.mounted) {
                                        Provider.of<AppState>(context, listen: false).notifyListeners();
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Passer commande',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

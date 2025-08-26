import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bunyan/models/models.dart';

// 1. The State Notifier for the cart
class CartNotifier extends StateNotifier<List<CartItemModel>> {
  // Initialize with an empty list
  CartNotifier() : super([]);

  void addItem(ProductModel product, int quantity) {
    final itemIndex = state.indexWhere((item) => item.product.id == product.id);

    if (itemIndex != -1) {
      // If the item already exists, update its quantity
      final existingItem = state[itemIndex];
      final updatedItem =
          existingItem.copyWith(quantity: existingItem.quantity + quantity);
      final newState = List<CartItemModel>.from(state);
      newState[itemIndex] = updatedItem;
      state = newState;
    } else {
      // Otherwise, add the new item to the list
      state = [...state, CartItemModel(product: product, quantity: quantity)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int newQuantity) {
    // If quantity is zero or less, remove the item
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    // Otherwise, update the quantity of the existing item
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: newQuantity)
        else
          item,
    ];
  }

  void clearCart() {
    state = [];
  }
}

// 2. The StateNotifierProvider
final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});

// 3. A provider to calculate the total price of the cart
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.totalPrice);
});

// 4. A provider to get the total number of items in the cart
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (total, item) => total + item.quantity);
});

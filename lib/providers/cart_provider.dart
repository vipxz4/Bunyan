import 'package:bonyan/constants/firestore_collections.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/data_providers.dart';
import 'package:bonyan/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Cart Actions Provider (No changes needed, code is correct) ---

class CartActions {
  CartActions(this._ref);
  final Ref _ref;

  // Helper to get the current user's cart collection reference
  CollectionReference<Map<String, dynamic>>? _getCartRef() {
    final user = _ref.read(userDetailsProvider).asData?.value;
    if (user == null) return null;
    return FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(user.id)
        .collection('cart_items');
  }

  Future<void> addItem(ProductModel product, int quantity) async {
    final cartRef = _getCartRef();
    if (cartRef == null) throw Exception('User not logged in.');

    final docRef = cartRef.doc(product.id);
    final doc = await docRef.get();

    if (doc.exists) {
      // If item exists, increment quantity
      await docRef.update({'quantity': FieldValue.increment(quantity)});
    } else {
      // If item doesn't exist, create it
      final newItem = CartItemModel(id: product.id, product: product, quantity: quantity);
      await docRef.set(newItem.toJson());
    }
  }

  Future<void> removeItem(String productId) async {
    final cartRef = _getCartRef();
    if (cartRef == null) throw Exception('User not logged in.');
    await cartRef.doc(productId).delete();
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    final cartRef = _getCartRef();
    if (cartRef == null) throw Exception('User not logged in.');

    if (newQuantity <= 0) {
      await removeItem(productId);
    } else {
      await cartRef.doc(productId).update({'quantity': newQuantity});
    }
  }

  Future<void> clearCart() async {
    final cartRef = _getCartRef();
    if (cartRef == null) return; // No user, no cart to clear

    final snapshot = await cartRef.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}

final cartActionsProvider = Provider<CartActions>((ref) {
  return CartActions(ref);
});


// --- Cart Data Provider (No changes needed, code is correct) ---

final cartProvider = StreamProvider.autoDispose<List<CartItemModel>>((ref) {
  final user = ref.watch(userDetailsProvider).asData?.value;
  if (user == null) {
    return Stream.value([]); // Return empty stream if no user
  }

  final service = ref.watch(firestoreServiceProvider(
      '${FirestoreCollections.users}/${user.id}/cart_items'));

  return service.collectionStream<CartItemModel>(
    builder: (data, documentId) => CartItemModel.fromJson(data!, documentId),
  );
});


// --- Derived Providers (Slightly improved for robustness) ---

final cartTotalProvider = Provider.autoDispose<double>((ref) {
  // We watch the async value of the cart provider
  final cartAsyncValue = ref.watch(cartProvider);

  // **IMPROVEMENT**: Use .maybeWhen to handle all states gracefully.
  // This is safer than checking 'asData' alone.
  return cartAsyncValue.maybeWhen(
    // If we have data, calculate the total
    data: (cart) => cart.fold(0, (total, item) => total + item.totalPrice),
    // In all other cases (loading, error), return 0
    orElse: () => 0,
  );
});

final cartItemCountProvider = Provider.autoDispose<int>((ref) {
  final cartAsyncValue = ref.watch(cartProvider);

  // **IMPROVEMENT**: Use .maybeWhen here as well.
  return cartAsyncValue.maybeWhen(
    data: (cart) => cart.fold(0, (total, item) => total + item.quantity),
    orElse: () => 0,
  );
});
import 'package:bunyan/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class CartItemModel {
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.product,
    required this.quantity,
  });

  CartItemModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  // Override equals and hashCode to make it easy to find and update
  // items in the cart list based on the product ID.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItemModel && other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;
}

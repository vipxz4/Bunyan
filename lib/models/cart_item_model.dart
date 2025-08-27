import 'package:bonyan/models/product_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class CartItemModel {
  final String id; // This will be the product ID
  final ProductModel product;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json, String id) {
    return CartItemModel(
      id: id,
      // The product data is nested within the cart item document
      product: ProductModel.fromJson(json['product'], json['product']['id'] ?? id),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      // Store the entire product object so we don't have to fetch it separately
      'product': product.toJson(),
    };
  }


  CartItemModel copyWith({
    String? id,
    ProductModel? product,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
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

    return other is CartItemModel &&
      other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

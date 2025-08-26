import 'package:flutter/foundation.dart';

@immutable
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String unit; // e.g., 'للقطعة', 'للكيس (50 كجم)'
  final String imageUrl;
  final String supplierId;
  final String supplierName;
  final String description;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.supplierId,
    required this.supplierName,
    required this.description,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? unit,
    String? imageUrl,
    String? supplierId,
    String? supplierName,
    String? description,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      imageUrl: imageUrl ?? this.imageUrl,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      description: description ?? this.description,
    );
  }
}

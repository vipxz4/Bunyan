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
  final int stock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.supplierId,
    required this.supplierName,
    required this.description,
    this.stock = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      supplierId: json['supplierId'] ?? '',
      supplierName: json['supplierName'] ?? '',
      description: json['description'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'unit': unit,
      'imageUrl': imageUrl,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'description': description,
      'stock': stock,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? unit,
    String? imageUrl,
    String? supplierId,
    String? supplierName,
    String? description,
    int? stock,
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
      stock: stock ?? this.stock,
    );
  }
}

import 'package:flutter/foundation.dart';

@immutable
class SupplierModel {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final String? avatarUrl;
  final String deliveryPolicy;

  const SupplierModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    this.avatarUrl,
    required this.deliveryPolicy,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json, String id) {
    return SupplierModel(
      id: id,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      avatarUrl: json['avatarUrl'],
      deliveryPolicy: json['deliveryPolicy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'reviewCount': reviewCount,
      'avatarUrl': avatarUrl,
      'deliveryPolicy': deliveryPolicy,
    };
  }

  SupplierModel copyWith({
    String? id,
    String? name,
    String? specialty,
    double? rating,
    int? reviewCount,
    ValueGetter<String?>? avatarUrl,
    String? deliveryPolicy,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      avatarUrl: avatarUrl != null ? avatarUrl() : this.avatarUrl,
      deliveryPolicy: deliveryPolicy ?? this.deliveryPolicy,
    );
  }
}

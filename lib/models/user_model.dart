import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? avatarUrl;
  final String role; // e.g., 'عميل', 'مهني/مقاول', 'مورد'

  final List<String> favoriteProductIds;
  final List<String> favoriteProfessionalIds;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.avatarUrl,
    required this.role,
    this.favoriteProductIds = const [],
    this.favoriteProfessionalIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'عميل',
      favoriteProductIds: List<String>.from(json['favoriteProductIds'] ?? []),
      favoriteProfessionalIds:
          List<String>.from(json['favoriteProfessionalIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'avatarUrl': avatarUrl,
      'role': role,
      'favoriteProductIds': favoriteProductIds,
      'favoriteProfessionalIds': favoriteProfessionalIds,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? role,
    List<String>? favoriteProductIds,
    List<String>? favoriteProfessionalIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      favoriteProfessionalIds:
          favoriteProfessionalIds ?? this.favoriteProfessionalIds,
    );
  }
}

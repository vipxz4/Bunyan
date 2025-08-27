import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String fullName;
  final String? phoneNumber;
  final String? avatarUrl;
  final String role; // e.g., 'عميل', 'مهني/مقاول', 'مورد'

  // Common fields
  final List<String> favoriteProductIds;
  final List<String> favoriteProfessionalIds;

  // Supplier-specific fields
  final String? companyName;
  final String? address;

  // Professional-specific fields
  final String? specialization;
  final int? yearsOfExperience;

  const UserModel({
    required this.id,
    required this.fullName,
    this.phoneNumber,
    this.avatarUrl,
    required this.role,
    this.favoriteProductIds = const [],
    this.favoriteProfessionalIds = const [],
    this.companyName,
    this.address,
    this.specialization,
    this.yearsOfExperience,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String id) {
    return UserModel(
      id: id,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'],
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'عميل',
      favoriteProductIds: List<String>.from(json['favoriteProductIds'] ?? []),
      favoriteProfessionalIds:
          List<String>.from(json['favoriteProfessionalIds'] ?? []),
      companyName: json['companyName'],
      address: json['address'],
      specialization: json['specialization'],
      yearsOfExperience: json['yearsOfExperience'],
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
      'companyName': companyName,
      'address': address,
      'specialization': specialization,
      'yearsOfExperience': yearsOfExperience,
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
    String? companyName,
    String? address,
    String? specialization,
    int? yearsOfExperience,
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
      companyName: companyName ?? this.companyName,
      address: address ?? this.address,
      specialization: specialization ?? this.specialization,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
    );
  }
}

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
  final String? productType;

  // Professional-specific fields
  final String? specialization;
  final int? yearsOfExperience;
  final String? certifications;
  final String? portfolio;

  // Metadata
  final bool isProfileComplete;

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
    this.productType,
    this.specialization,
    this.yearsOfExperience,
    this.certifications,
    this.portfolio,
    this.isProfileComplete = false,
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
      productType: json['productType'],
      specialization: json['specialization'],
      yearsOfExperience: json['yearsOfExperience'],
      certifications: json['certifications'],
      portfolio: json['portfolio'],
      isProfileComplete: json['isProfileComplete'] ?? false,
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
      'productType': productType,
      'specialization': specialization,
      'yearsOfExperience': yearsOfExperience,
      'certifications': certifications,
      'portfolio': portfolio,
      'isProfileComplete': isProfileComplete,
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
    String? productType,
    String? specialization,
    int? yearsOfExperience,
    String? certifications,
    String? portfolio,
    bool? isProfileComplete,
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
      productType: productType ?? this.productType,
      specialization: specialization ?? this.specialization,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      certifications: certifications ?? this.certifications,
      portfolio: portfolio ?? this.portfolio,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }
}

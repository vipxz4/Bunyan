import 'package:flutter/foundation.dart';

@immutable
class ProfessionalModel {
  final String id;
  final String name;
  final String specialty; // e.g., 'مقاول عام'
  final String location;
  final double rating;
  final int reviewCount;
  final String? avatarUrl;
  final String? backgroundUrl;
  final bool isVerified;
  final bool acceptsWarrantyPayment;
  final String bio;
  final List<String> portfolioImageUrls;

  const ProfessionalModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.avatarUrl,
    this.backgroundUrl,
    required this.isVerified,
    required this.acceptsWarrantyPayment,
    required this.bio,
    required this.portfolioImageUrls,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json, String id) {
    return ProfessionalModel(
      id: id,
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      location: json['location'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      avatarUrl: json['avatarUrl'],
      backgroundUrl: json['backgroundUrl'],
      isVerified: json['isVerified'] ?? false,
      acceptsWarrantyPayment: json['acceptsWarrantyPayment'] ?? false,
      bio: json['bio'] ?? '',
      portfolioImageUrls: List<String>.from(json['portfolioImageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'avatarUrl': avatarUrl,
      'backgroundUrl': backgroundUrl,
      'isVerified': isVerified,
      'acceptsWarrantyPayment': acceptsWarrantyPayment,
      'bio': bio,
      'portfolioImageUrls': portfolioImageUrls,
    };
  }

  ProfessionalModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? location,
    double? rating,
    int? reviewCount,
    ValueGetter<String?>? avatarUrl,
    ValueGetter<String?>? backgroundUrl,
    bool? isVerified,
    bool? acceptsWarrantyPayment,
    String? bio,
    List<String>? portfolioImageUrls,
  }) {
    return ProfessionalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      avatarUrl: avatarUrl != null ? avatarUrl() : this.avatarUrl,
      backgroundUrl: backgroundUrl != null ? backgroundUrl() : this.backgroundUrl,
      isVerified: isVerified ?? this.isVerified,
      acceptsWarrantyPayment:
          acceptsWarrantyPayment ?? this.acceptsWarrantyPayment,
      bio: bio ?? this.bio,
      portfolioImageUrls: portfolioImageUrls ?? this.portfolioImageUrls,
    );
  }
}

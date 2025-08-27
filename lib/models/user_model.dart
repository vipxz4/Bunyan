import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? avatarUrl;
  final String role; // e.g., 'عميل', 'مهني/مقاول', 'مورد'

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.avatarUrl,
    required this.role,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
    );
  }
}

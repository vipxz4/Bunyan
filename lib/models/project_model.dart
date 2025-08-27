import 'package:flutter/foundation.dart';

enum ProjectType { humanResource, material, purchaseRequest }

import 'package:cloud_firestore/cloud_firestore.dart';

extension ProjectTypeExtension on ProjectType {
  String get displayName {
    switch (this) {
      case ProjectType.humanResource:
        return 'خدمة موارد بشرية';
      case ProjectType.material:
        return 'طلب مواد';
      case ProjectType.purchaseRequest:
        return 'طلب شراء';
      default:
        return '';
    }
  }

  static ProjectType fromString(String? typeString) {
    return ProjectType.values.firstWhere(
      (type) => type.name == typeString,
      orElse: () => ProjectType.humanResource, // Default value
    );
  }
}

@immutable
class ProjectModel {
  final String id;
  final String userId; // ID of the user who owns the project
  final String name;
  final String status;
  final double progress; // 0.0 to 1.0
  final ProjectType type;
  final String? clientName; // For provider view
  final String? providerName; // For client view
  final DateTime? date;

  const ProjectModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.status,
    this.progress = 0.0,
    required this.type,
    this.clientName,
    this.providerName,
    this.date,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json, String id) {
    return ProjectModel(
      id: id,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      progress: (json['progress'] ?? 0.0).toDouble(),
      type: ProjectTypeExtension.fromString(json['type']),
      clientName: json['clientName'],
      providerName: json['providerName'],
      date: (json['date'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'status': status,
      'progress': progress,
      'type': type.name,
      if (clientName != null) 'clientName': clientName,
      if (providerName != null) 'providerName': providerName,
      if (date != null) 'date': Timestamp.fromDate(date!),
    };
  }

  ProjectModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? status,
    double? progress,
    ProjectType? type,
    ValueGetter<String?>? clientName,
    ValueGetter<String?>? providerName,
    ValueGetter<DateTime?>? date,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      type: type ?? this.type,
      clientName: clientName != null ? clientName() : this.clientName,
      providerName: providerName != null ? providerName() : this.providerName,
      date: date != null ? date() : this.date,
    );
  }
}

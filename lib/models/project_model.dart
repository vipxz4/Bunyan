import 'package:flutter/foundation.dart';

enum ProjectType { humanResource, material, purchaseRequest }

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
}

@immutable
class ProjectModel {
  final String id;
  final String name;
  final String status;
  final double progress; // 0.0 to 1.0
  final ProjectType type;
  final String? clientName; // For provider view
  final String? providerName; // For client view
  final DateTime? date;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.status,
    this.progress = 0.0,
    required this.type,
    this.clientName,
    this.providerName,
    this.date,
  });

  ProjectModel copyWith({
    String? id,
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

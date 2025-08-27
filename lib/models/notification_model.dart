import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum NotificationType {
  offer,
  payment,
  milestone,
  message,
}

extension NotificationTypeExtension on NotificationType {
  IconData get icon {
    switch (this) {
      case NotificationType.offer:
        return LucideIcons.messageSquare;
      case NotificationType.payment:
        return LucideIcons.checkCircle;
      case NotificationType.milestone:
        return LucideIcons.alertTriangle;
      case NotificationType.message:
        return LucideIcons.messageSquare;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.offer:
        return const Color(0xFF4A4E9D); // primary
      case NotificationType.payment:
        return Colors.green.shade500;
      case NotificationType.milestone:
        return Colors.yellow.shade700;
      case NotificationType.message:
        return const Color(0xFF4A4E9D); // primary
    }
  }

  static NotificationType fromString(String? typeString) {
    return NotificationType.values.firstWhere(
      (type) => type.name == typeString,
      orElse: () => NotificationType.message, // Default value
    );
  }
}

@immutable
class NotificationModel {
  final String id;
  final String userId; // ID of the user this notification is for
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      type: NotificationTypeExtension.fromString(json['type']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name,
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}

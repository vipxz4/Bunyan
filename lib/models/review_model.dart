import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class ReviewModel {
  final String id;
  final String authorId;
  final String authorName;
  final String targetId; // ID of the professional or supplier being reviewed
  final String? targetName; // Name of the professional or supplier being reviewed
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.targetId,
    this.targetName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    return ReviewModel(
      id: id,
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      targetId: json['targetId'] ?? '',
      targetName: json['targetName'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'targetId': targetId,
      'targetName': targetName,
      'rating': rating,
      'comment': comment,
      'date': Timestamp.fromDate(date),
    };
  }

  ReviewModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? targetId,
    String? targetName,
    double? rating,
    String? comment,
    DateTime? date,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      targetId: targetId ?? this.targetId,
      targetName: targetName ?? this.targetName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
    );
  }
}

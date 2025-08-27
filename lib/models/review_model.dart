import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class ReviewModel {
  final String id;
  final String authorId;
  final String authorName;
  final double rating;
  final String comment;
  final DateTime date;
  final String? targetName; // Name of the professional or supplier being reviewed

  const ReviewModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
    this.targetName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    return ReviewModel(
      id: id,
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      targetName: json['targetName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'rating': rating,
      'comment': comment,
      'date': Timestamp.fromDate(date),
      if (targetName != null) 'targetName': targetName,
    };
  }

  ReviewModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    double? rating,
    String? comment,
    DateTime? date,
    String? targetName,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      targetName: targetName ?? this.targetName,
    );
  }
}

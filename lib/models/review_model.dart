import 'package:flutter/foundation.dart';

@immutable
class ReviewModel {
  final String id;
  final String authorName;
  final double rating;
  final String comment;
  final DateTime date;
  final String? targetName; // Name of the professional or supplier being reviewed

  const ReviewModel({
    required this.id,
    required this.authorName,
    required this.rating,
    required this.comment,
    required this.date,
    this.targetName,
  });

  ReviewModel copyWith({
    String? id,
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

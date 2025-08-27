import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChatMessageModel {
  final String id;
  final String text;
  final DateTime timestamp;
  final String senderId;
  final bool isMe;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.senderId,
    required this.isMe,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json, String id) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return ChatMessageModel(
      id: id,
      text: json['text'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      senderId: json['senderId'] ?? '',
      isMe: json['senderId'] == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderId': senderId,
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? text,
    DateTime? timestamp,
    String? senderId,
    bool? isMe,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      isMe: isMe ?? this.isMe,
    );
  }
}

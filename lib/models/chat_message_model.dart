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

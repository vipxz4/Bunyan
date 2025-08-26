import 'package:flutter/foundation.dart';

@immutable
class ChatThreadModel {
  final String id;
  final String otherPartyName;
  final String? otherPartyAvatarUrl;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;
  final bool isOnline;

  const ChatThreadModel({
    required this.id,
    required this.otherPartyName,
    this.otherPartyAvatarUrl,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    required this.isOnline,
  });

  ChatThreadModel copyWith({
    String? id,
    String? otherPartyName,
    ValueGetter<String?>? otherPartyAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatThreadModel(
      id: id ?? this.id,
      otherPartyName: otherPartyName ?? this.otherPartyName,
      otherPartyAvatarUrl: otherPartyAvatarUrl != null
          ? otherPartyAvatarUrl()
          : this.otherPartyAvatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

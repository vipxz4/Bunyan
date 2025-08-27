import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class ChatThreadModel {
  final String id;
  final List<String> participantIds;
  final String otherPartyName;
  final String? otherPartyAvatarUrl;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;
  final bool isOnline;

  const ChatThreadModel({
    required this.id,
    required this.participantIds,
    required this.otherPartyName,
    this.otherPartyAvatarUrl,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    required this.isOnline,
  });

  factory ChatThreadModel.fromJson(Map<String, dynamic> json, String id) {
    return ChatThreadModel(
      id: id,
      participantIds: List<String>.from(json['participantIds'] ?? []),
      otherPartyName: json['otherPartyName'] ?? '',
      otherPartyAvatarUrl: json['otherPartyAvatarUrl'],
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTimestamp: (json['lastMessageTimestamp'] as Timestamp).toDate(),
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantIds': participantIds,
      'otherPartyName': otherPartyName,
      'otherPartyAvatarUrl': otherPartyAvatarUrl,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': Timestamp.fromDate(lastMessageTimestamp),
      'unreadCount': unreadCount,
      'isOnline': isOnline,
    };
  }

  ChatThreadModel copyWith({
    String? id,
    List<String>? participantIds,
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

import 'package:badges/badges.dart' as badges;
import 'package:bunyan/core/app_theme.dart';
import 'package:bunyan/models/chat_thread_model.dart';
import 'package:bunyan/providers/providers.dart';
import 'package:bunyan/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatThreads = ref.watch(chatThreadsProvider);
    return Scaffold(
      appBar: const ScreenHeader(title: 'الرسائل'),
      body: ListView.separated(
        itemCount: chatThreads.length,
        itemBuilder: (context, index) {
          final thread = chatThreads[index];
          return _ChatThreadCard(thread: thread);
        },
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 80),
      ),
    );
  }
}

class _ChatThreadCard extends StatelessWidget {
  const _ChatThreadCard({required this.thread});

  final ChatThreadModel thread;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => context.push('/home/chat/${thread.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            badges.Badge(
              showBadge: thread.isOnline,
              badgeStyle: const badges.BadgeStyle(badgeColor: AppTheme.green),
              position: badges.BadgePosition.bottomEnd(bottom: 0, end: 0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: thread.otherPartyAvatarUrl != null
                    ? CachedNetworkImageProvider(thread.otherPartyAvatarUrl!)
                    : null,
                child: thread.otherPartyAvatarUrl == null
                    ? const Icon(LucideIcons.user)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(thread.otherPartyName, style: textTheme.titleLarge),
                      Text(
                        timeago.format(thread.lastMessageTimestamp, locale: 'ar'),
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          thread.lastMessage,
                          style: textTheme.bodyMedium?.copyWith(
                              fontWeight: thread.unreadCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: thread.unreadCount > 0
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (thread.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        badges.Badge(
                          badgeContent: Text('${thread.unreadCount}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

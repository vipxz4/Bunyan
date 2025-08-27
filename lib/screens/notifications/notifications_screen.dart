import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/notification_model.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsyncValue = ref.watch(notificationsProvider);
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return Scaffold(
      appBar: const ScreenHeader(title: 'الإشعارات'),
      body: notificationsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorDisplayWidget(errorMessage: err.toString()),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text('لا توجد إشعارات حالياً.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationCard(notification: notification);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends ConsumerWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        // Mark as read when tapped
        if (!notification.isRead) {
          ref.read(notificationActionsProvider).markAsRead(notification.id);
        }
        // Navigate to details
        context.push('/home/notifications/${notification.id}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? AppTheme.surface : AppTheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: notification.type.color,
              child: Icon(notification.type.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text(notification.body, style: textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    timeago.format(notification.timestamp, locale: 'ar'),
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

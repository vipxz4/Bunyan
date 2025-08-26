import 'package:bunyan/core/app_theme.dart';
import 'package:bunyan/models/notification_model.dart';
import 'package:bunyan/providers/providers.dart';
import 'package:bunyan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    return Scaffold(
      appBar: const ScreenHeader(title: 'الإشعارات'),
      body: notifications.isEmpty
          ? const Center(child: Text('لا توجد إشعارات حالياً.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationCard(notification: notification);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => context.push('/home/notifications/${notification.id}'),
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

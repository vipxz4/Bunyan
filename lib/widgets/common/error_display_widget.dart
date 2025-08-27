import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.serverCrash, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ ما',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'نعتذر، لم نتمكن من تحميل البيانات. الرجاء المحاولة مرة أخرى.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            // Uncomment the line below to show technical error details for debugging
            // Text(errorMessage, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw),
                label: const Text('إعادة المحاولة'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

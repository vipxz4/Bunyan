import 'package:bonyan/core/app_theme.dart';
import 'package:bonyan/models/models.dart';
import 'package:bonyan/providers/providers.dart';
import 'package:bonyan/widgets/common/error_display_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatInterfaceScreen extends ConsumerWidget {
  const ChatInterfaceScreen({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadAsyncValue = ref.watch(chatThreadsProvider);
    final messagesAsyncValue = ref.watch(chatMessagesProvider(chatId));

    // Find the specific thread from the list of threads
    final thread = threadAsyncValue.asData?.value
        .firstWhere((t) => t.id == chatId, orElse: () => null as ChatThreadModel);

    if (thread == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('لم يتم العثور على المحادثة')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: thread.otherPartyAvatarUrl != null
                  ? CachedNetworkImageProvider(thread.otherPartyAvatarUrl!)
                  : null,
              child: thread.otherPartyAvatarUrl == null ? const Icon(LucideIcons.user) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(thread.otherPartyName, style: Theme.of(context).textTheme.titleLarge),
                if (thread.isOnline)
                  Text(
                    'متصل الآن',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.green),
                  ),
              ],
            )
          ],
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsyncValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  ErrorDisplayWidget(errorMessage: err.toString()),
              data: (messages) => ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(16.0),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
          ),
          _MessageInputBar(chatId: chatId),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessageModel message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final theme = Theme.of(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primary : AppTheme.lightGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyLarge?.copyWith(color: isMe ? Colors.white : AppTheme.textPrimary),
        ),
      ),
    );
  }
}

class _MessageInputBar extends ConsumerStatefulWidget {
  const _MessageInputBar({required this.chatId});
  final String chatId;

  @override
  ConsumerState<_MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends ConsumerState<_MessageInputBar> {
  final _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    final user = ref.read(userDetailsProvider).asData?.value;
    if (user == null) return;

    setState(() => _isSending = true);

    try {
      await ref.read(chatActionsProvider).sendMessage(
            chatId: widget.chatId,
            text: text,
            senderId: user.id,
          );
      _controller.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إرسال الرسالة: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: AppTheme.surface,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(LucideIcons.paperclip, color: AppTheme.textSecondary)),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  fillColor: AppTheme.lightGray,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _isSending ? null : _sendMessage,
              icon: _isSending ? const CircularProgressIndicator() : const Icon(LucideIcons.send),
              style: IconButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

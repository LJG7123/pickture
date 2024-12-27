import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/chat_provider.dart';
import '../../../../core/error/error_provider.dart';

class ChatMessageInput extends ConsumerStatefulWidget {
  final String chatId;

  const ChatMessageInput({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends ConsumerState<ChatMessageInput> {
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    if (!mounted) return;

    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await ref.read(sendMessageProvider((
        chatId: widget.chatId,
        content: message,
        senderId: currentUser.uid,
      )).future);

      if (!mounted) return;
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      ref.read(errorNotifierProvider.notifier).setError(
            e is AppException ? e : AppException('메시지 전송에 실패했습니다'),
          );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: '메시지 보내기...',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

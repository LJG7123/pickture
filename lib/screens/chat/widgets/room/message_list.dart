import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../models/message.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/user_provider.dart';
import '../../../../core/error/error_provider.dart';
import '../../../../utils/date_util.dart';

class ChatMessageList extends ConsumerWidget {
  final String chatId;
  final AsyncValue<List<Message>> messagesAsync;
  final bool isGroupChat;

  const ChatMessageList({
    super.key,
    required this.chatId,
    required this.messagesAsync,
    required this.isGroupChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider).value;

    return messagesAsync.when(
      data: (messages) {
        String? currentDate;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final messageDate = message.sentTime.formatMessageDateOnly();

            final showDateDivider = currentDate != messageDate;
            if (showDateDivider) {
              currentDate = messageDate;
            }

            final isMe = message.senderId == currentUser?.uid;
            return Column(
              children: [
                if (showDateDivider) _buildDateDivider(context, messageDate),
                _buildMessageItem(context, ref, message, isMe),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        ref.read(errorNotifierProvider.notifier).setError(
              error is AppException ? error : AppException('메시지를 불러오는데 실패했습니다'),
            );
        return Center(
          child: Text(
            '메시지를 불러오는데 실패했습니다',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );
      },
    );
  }

  Widget _buildDateDivider(BuildContext context, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, WidgetRef ref, Message message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _buildSenderInfo(context, ref, message),
            const SizedBox(width: 8),
          ],
          _buildMessageBubble(context, message, isMe),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, Message message, bool isMe) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isMe ? colorScheme.primary : colorScheme.surfaceContainerHighest.withOpacity(0.8),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isMe ? 20 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 20),
        ),
      ),
      child: Text(
        message.isDeleted ? '삭제된 메시지입니다' : message.content,
        style: TextStyle(
          color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSenderInfo(BuildContext context, WidgetRef ref, Message message) {
    return ref.watch(userProvider(message.senderId)).when(
          data: (user) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundImage: user?.profileImage?.isNotEmpty == true ? NetworkImage(user!.profileImage!) : null,
                child: user?.profileImage?.isNotEmpty != true ? const Icon(Icons.person, size: 12) : null,
              ),
              if (isGroupChat)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    user?.name ?? '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          loading: () => const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const SizedBox(width: 24, height: 24),
        );
  }
}

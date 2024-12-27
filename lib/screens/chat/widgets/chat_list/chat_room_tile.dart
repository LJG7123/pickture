import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/chat_room.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/chat_provider.dart';
import '../../../../utils/date_util.dart';

class ChatRoomTile extends ConsumerWidget {
  final String chatId;

  const ChatRoomTile({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomWithUserAsync = ref.watch(chatRoomWithUserProvider(chatId));

    return chatRoomWithUserAsync.when(
      data: (data) {
        final chatRoom = data.chatRoom;
        final user = data.otherUser;

        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            backgroundImage: chatRoom.isGroupChat
                ? (chatRoom.groupImage?.isNotEmpty == true ? NetworkImage(chatRoom.groupImage!) : null)
                : (user?.profileImage?.isNotEmpty == true ? NetworkImage(user!.profileImage!) : null),
            child: _buildLeadingIcon(context, chatRoom, user),
          ),
          title: Text(
            chatRoom.isGroupChat ? (chatRoom.groupName ?? '그룹 채팅') : (user?.name ?? ''),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            chatRoom.lastMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            chatRoom.lastMessageTime.formatMessageDate(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          onTap: () => context.go('/chats/${chatRoom.id}'),
        );
      },
      loading: () => const ListTile(
        leading: CircleAvatar(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        title: Text('로딩 중...'),
      ),
      error: (error, stack) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.error,
          child: Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
        ),
        title: Text(
          '오류 발생',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget? _buildLeadingIcon(BuildContext context, ChatRoom chatRoom, UserModel? user) {
    if (chatRoom.isGroupChat) {
      return chatRoom.groupImage?.isNotEmpty != true ? Icon(Icons.group, color: Theme.of(context).colorScheme.onSurface) : null;
    }
    return user?.profileImage?.isNotEmpty != true ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface) : null;
  }
}

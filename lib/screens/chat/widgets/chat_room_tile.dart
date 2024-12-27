import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/chat_provider.dart';
import '../../../models/chat_room.dart';

class ChatRoomTile extends ConsumerWidget {
  final ChatRoom chatRoom;

  const ChatRoomTile({
    super.key,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomAsync = ref.watch(chatRoomProvider(chatRoom.id));
    final otherUserAsync = !chatRoom.isGroupChat
        ? chatRoomAsync.when(
            data: (chatRoom) => ref.watch(chatRoomUserProvider(chatRoom)),
            loading: () => const AsyncValue.loading(),
            error: (err, stack) => AsyncValue.error(err, stack),
          )
        : const AsyncValue.data(null);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        radius: 20,
        backgroundImage: !chatRoom.isGroupChat && otherUserAsync.value?.profileImage != null && otherUserAsync.value!.profileImage!.isNotEmpty
            ? NetworkImage(otherUserAsync.value!.profileImage!)
            : null,
        child: chatRoom.isGroupChat
            ? Icon(Icons.group, color: Theme.of(context).colorScheme.onSurface, size: 20)
            : (otherUserAsync.value?.profileImage == null || otherUserAsync.value!.profileImage!.isEmpty
                ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface, size: 20)
                : null),
      ),
      title: Text(
        chatRoom.isGroupChat ? chatRoom.groupName ?? '그룹 채팅' : otherUserAsync.value?.name ?? '로딩 중...',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
          height: 1.2,
        ),
      ),
      subtitle: Text(
        chatRoom.isGroupChat ? '${chatRoom.participants.length}명 · ${chatRoom.lastMessage}' : chatRoom.lastMessage,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 14,
          height: 1.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onTap: () => context.go('/chats/${chatRoom.id}'),
    );
  }
}

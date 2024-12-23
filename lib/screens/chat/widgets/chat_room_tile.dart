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
        backgroundColor: Colors.grey[800],
        radius: 20,
        backgroundImage: !chatRoom.isGroupChat &&
                otherUserAsync.value?.profileImage != null &&
                otherUserAsync.value!.profileImage!.isNotEmpty
            ? NetworkImage(otherUserAsync.value!.profileImage!)
            : null,
        child: chatRoom.isGroupChat
            ? const Icon(Icons.group, color: Colors.white, size: 20)
            : (otherUserAsync.value?.profileImage == null ||
                    otherUserAsync.value!.profileImage!.isEmpty
                ? const Icon(Icons.person, color: Colors.white, size: 20)
                : null),
      ),
      title: Text(
        chatRoom.isGroupChat
            ? chatRoom.groupName ?? '그룹 채팅'
            : otherUserAsync.value?.name ?? '로딩 중...',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.2,
        ),
      ),
      subtitle: Text(
        chatRoom.isGroupChat
            ? '${chatRoom.participants.length}명 · ${chatRoom.lastMessage}'
            : chatRoom.lastMessage,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          height: 1.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
        size: 16,
      ),
      onTap: () => context.go('/chats/${chatRoom.id}'),
    );
  }
}

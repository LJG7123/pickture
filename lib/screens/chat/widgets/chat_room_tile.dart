import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/chat_room.dart';
import '../../../providers/chat_provider.dart';

class ChatRoomTile extends ConsumerWidget {
  final ChatRoom chatRoom;

  const ChatRoomTile({
    super.key,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otherUserAsync = ref.watch(chatRoomUserProvider(chatRoom));

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[800],
        radius: 20,
        backgroundImage: otherUserAsync.value?.profileImage != null &&
                otherUserAsync.value!.profileImage!.isNotEmpty
            ? NetworkImage(otherUserAsync.value!.profileImage!)
            : null,
        child: otherUserAsync.value?.profileImage == null ||
                otherUserAsync.value!.profileImage!.isEmpty
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(
        otherUserAsync.value?.name ?? '로딩 중...',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      subtitle: Text(
        chatRoom.lastMessage,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
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

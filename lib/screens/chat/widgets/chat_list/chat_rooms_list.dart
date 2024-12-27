import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/chat_room.dart';
import 'chat_room_tile.dart';

class ChatRoomsList extends ConsumerWidget {
  final AsyncValue<List<ChatRoom>> chatRoomsAsync;

  const ChatRoomsList({
    super.key,
    required this.chatRoomsAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return chatRoomsAsync.when(
      data: (chatRooms) {
        if (chatRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  '채팅방이 없습니다',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            final chatRoom = chatRooms[index];
            return ChatRoomTile(chatId: chatRoom.id);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          '채팅방을 불러오는데 실패했습니다',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

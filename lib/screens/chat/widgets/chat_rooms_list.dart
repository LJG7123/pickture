import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/chat_room.dart';
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '아직 메시지가 없습니다.',
                  style: TextStyle(
                    color: Colors.white,
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
            return ChatRoomTile(chatRoom: chatRooms[index]);
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stack) => const Center(
        child: Text(
          '채팅방 목록을 불러오는 중 오류가 발생했습니다.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

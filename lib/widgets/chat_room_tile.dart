import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/chat_room.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatRoomTile({
    super.key,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        'another_person', // TODO: 상대방 이름
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
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

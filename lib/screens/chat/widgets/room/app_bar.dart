import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/chat_room.dart';
import '../../../../models/user_model.dart';

class ChatRoomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final AsyncValue<({ChatRoom chatRoom, UserModel? otherUser})> chatRoomWithUserAsync;

  const ChatRoomAppBar({
    super.key,
    required this.chatRoomWithUserAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: chatRoomWithUserAsync.when(
        data: (data) {
          if (data.chatRoom.isGroupChat) {
            return _buildGroupTitle(data.chatRoom);
          } else {
            return _buildPrivateTitle(data.otherUser);
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text('오류 발생', style: TextStyle(color: Colors.white)),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTitle(ChatRoom chatRoom) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey[800],
          child: const Icon(Icons.group, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatRoom.groupName ?? '그룹 채팅',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${chatRoom.participants.length}명',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivateTitle(UserModel? otherUser) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: otherUser?.profileImage?.isNotEmpty == true ? NetworkImage(otherUser!.profileImage!) : null,
          child: otherUser?.profileImage?.isNotEmpty != true ? const Icon(Icons.person, color: Colors.white, size: 20) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otherUser?.name ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                otherUser?.userId ?? '',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

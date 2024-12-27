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
      backgroundColor: Theme.of(context).colorScheme.surface,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => context.pop(),
      ),
      title: chatRoomWithUserAsync.when(
        data: (data) {
          if (data.chatRoom.isGroupChat) {
            return _buildGroupTitle(context, data.chatRoom);
          } else {
            return _buildPrivateTitle(context, data.otherUser);
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => Text('오류 발생', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupTitle(BuildContext context, ChatRoom chatRoom) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(Icons.group, color: Theme.of(context).colorScheme.onSurface, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chatRoom.groupName ?? '그룹 채팅',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${chatRoom.participants.length}명',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrivateTitle(BuildContext context, UserModel? otherUser) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: otherUser?.profileImage?.isNotEmpty == true ? NetworkImage(otherUser!.profileImage!) : null,
          child: otherUser?.profileImage?.isNotEmpty != true ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface, size: 20) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                otherUser?.name ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                otherUser?.userId ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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

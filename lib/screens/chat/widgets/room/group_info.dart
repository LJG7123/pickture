import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/user_model.dart';
import '../../../../models/chat_room.dart';
import '../../../../providers/user_provider.dart';

class GroupInfoDrawer extends ConsumerWidget {
  final ChatRoom chatRoom;

  const GroupInfoDrawer({
    super.key,
    required this.chatRoom,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(usersByIdsProvider(chatRoom.participants));

    return Container(
      width: 300,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Divider(color: Theme.of(context).colorScheme.outline),
            Expanded(
              child: _buildParticipantsList(context, participantsAsync),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            backgroundImage: chatRoom.groupImage != null ? NetworkImage(chatRoom.groupImage!) : null,
            child: chatRoom.groupImage == null ? Icon(Icons.group, color: Theme.of(context).colorScheme.onSurface, size: 36) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatRoom.groupName ?? '그룹 채팅',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${chatRoom.participants.length}명의 참가자',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsList(BuildContext context, AsyncValue<List<UserModel>> participantsAsync) {
    return participantsAsync.when(
      data: (participants) {
        return ListView.builder(
          itemCount: participants.length,
          itemBuilder: (context, index) {
            final user = participants[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profileImage != null ? NetworkImage(user.profileImage!) : null,
                child: user.profileImage == null ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface) : null,
              ),
              title: Text(
                user.name,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
              subtitle: Text(
                user.userId,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          '참가자 정보를 불러오는데 실패했습니다',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

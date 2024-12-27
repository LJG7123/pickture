import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/cache/cache_provider.dart';
import '../../providers/chat_provider.dart';
import 'widgets/room/app_bar.dart';
import 'widgets/room/message_input.dart';
import 'widgets/room/message_list.dart';
import 'widgets/room/group_info.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String chatId;

  const ChatRoomScreen({
    super.key,
    required this.chatId,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  @override
  void initState() {
    super.initState();
    // 캐시 정리 스케줄러 활성화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheCleanupSchedulerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    final chatRoomWithUserAsync = ref.watch(chatRoomWithUserProvider(widget.chatId));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));

    // 메시지 목록이 업데이트될 때마다 보낸 사람 정보 프리로드
    messagesAsync.whenData((messages) {
      ref.read(messageUserIdsProvider.notifier).updateMessageUserIds(messages);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ChatRoomAppBar(
        chatRoomWithUserAsync: chatRoomWithUserAsync,
      ),
      endDrawer: Builder(
        builder: (context) => chatRoomWithUserAsync.when(
          data: (data) {
            if (!data.chatRoom.isGroupChat) return const SizedBox.shrink();
            return Drawer(
              child: GroupInfoDrawer(chatRoom: data.chatRoom),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(
            child: Text(
              '오류가 발생했습니다',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(
              chatId: widget.chatId,
              messagesAsync: messagesAsync,
              isGroupChat: chatRoomWithUserAsync.value?.chatRoom.isGroupChat ?? false,
            ),
          ),
          ChatMessageInput(chatId: widget.chatId),
        ],
      ),
    );
  }
}

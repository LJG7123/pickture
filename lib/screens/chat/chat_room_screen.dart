import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/date_util.dart';

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
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final otherUserAsync = ref.watch(chatRoomControllerProvider(widget.chatId));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: otherUserAsync.value?.profileImage != null &&
                      otherUserAsync.value!.profileImage!.isNotEmpty
                  ? NetworkImage(otherUserAsync.value!.profileImage!)
                  : null,
              child: otherUserAsync.value?.profileImage == null ||
                      otherUserAsync.value!.profileImage!.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherUserAsync.value?.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  otherUserAsync.value?.userId ?? '',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                // 날짜별로 메시지 그룹화
                String? currentDate;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageDate =
                        message.sentTime.formatMessageDateOnly();

                    // 날짜가 변경되면 날짜 구분선 표시
                    final showDateDivider = currentDate != messageDate;
                    if (showDateDivider) {
                      currentDate = messageDate;
                    }

                    final isMe =
                        message.senderId == ref.watch(authProvider).value?.uid;
                    return Column(
                      children: [
                        if (showDateDivider)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                messageDate,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: isMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe) ...[
                                CircleAvatar(
                                  radius: 12,
                                  backgroundImage: otherUserAsync
                                              .value?.profileImage !=
                                          null
                                      ? NetworkImage(
                                          otherUserAsync.value!.profileImage!)
                                      : null,
                                  child:
                                      otherUserAsync.value?.profileImage == null
                                          ? const Icon(Icons.person, size: 12)
                                          : null,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.blue : Colors.grey[800],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomLeft: Radius.circular(isMe ? 20 : 4),
                                    bottomRight: Radius.circular(isMe ? 4 : 20),
                                  ),
                                ),
                                child: Text(
                                  message.isDeleted
                                      ? '삭제된 메시지입니다'
                                      : message.content,
                                  style: TextStyle(
                                    color: message.isDeleted
                                        ? Colors.grey[400]
                                        : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                ref.read(errorNotifierProvider.notifier).setError(
                      error is AppException
                          ? error
                          : AppException('메시지를 불러오는데 실패했습니다'),
                    );
                return const Center(
                  child: Text(
                    '메시지를 불러오는데 실패했습니다',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border(
                top: BorderSide(color: Colors.grey[900]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined,
                      color: Colors.white),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: '메시지 보내기...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) {
                              ref
                                  .read(
                                      chatRoomControllerProvider(widget.chatId)
                                          .notifier)
                                  .sendMessageAndClear(
                                    widget.chatId,
                                    _messageController.text,
                                    _messageController,
                                  )
                                  .catchError((e) => ref
                                      .read(errorNotifierProvider.notifier)
                                      .setError(e));
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.image_outlined,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

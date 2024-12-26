import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
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
    if (!mounted) return const SizedBox.shrink();

    final chatRoomAsync = ref.watch(chatRoomProvider(widget.chatId));
    final otherUserAsync = chatRoomAsync.when(
      data: (chatRoom) {
        if (chatRoom.participants.length > 2) {
          return const AsyncValue.data(null);
        }
        return ref.watch(chatRoomUserProvider(chatRoom));
      },
      loading: () => const AsyncValue.loading(),
      error: (err, stack) => AsyncValue.error(err, stack),
    );
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));
    final currentUser = ref.watch(authProvider).value;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (mounted && context.mounted) {
              context.pop();
            }
          },
        ),
        title: chatRoomAsync.when(
          data: (chatRoom) {
            if (chatRoom.isGroupChat) {
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
            } else {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: otherUserAsync.value?.profileImage != null && otherUserAsync.value!.profileImage!.isNotEmpty
                        ? NetworkImage(otherUserAsync.value!.profileImage!)
                        : null,
                    child: otherUserAsync.value?.profileImage == null || otherUserAsync.value!.profileImage!.isEmpty
                        ? const Icon(Icons.person, color: Colors.white, size: 20)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          otherUserAsync.value?.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                  ),
                ],
              );
            }
          },
          loading: () => const CircularProgressIndicator(),
          error: (_, __) => const Text('오류 발생', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // TODO: 채팅방 정보 화면으로 이동
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (!mounted) return const SizedBox.shrink();
                String? currentDate;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final messageDate = message.sentTime.formatMessageDateOnly();

                    final showDateDivider = currentDate != messageDate;
                    if (showDateDivider) {
                      currentDate = messageDate;
                    }

                    final isMe = message.senderId == currentUser?.uid;
                    return Column(
                      children: [
                        if (showDateDivider)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (!isMe) ...[
                                FutureBuilder<UserModel?>(
                                  future: ref.read(userServiceProvider).getUser(message.senderId),
                                  builder: (context, snapshot) {
                                    final user = snapshot.data;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundImage: user?.profileImage != null ? NetworkImage(user!.profileImage!) : null,
                                          child: user?.profileImage == null ? const Icon(Icons.person, size: 12) : null,
                                        ),
                                        if (chatRoomAsync.value != null && chatRoomAsync.value!.participants.length > 2)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8, top: 4),
                                            child: Text(
                                              user?.name ?? '',
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                                  message.isDeleted ? '삭제된 메시지입니다' : message.content,
                                  style: TextStyle(
                                    color: message.isDeleted ? Colors.grey[400] : Colors.white,
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
                if (!mounted) return const SizedBox.shrink();
                ref.read(errorNotifierProvider.notifier).setError(
                      error is AppException ? error : AppException('메시지를 불러오는데 실패했습니다'),
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
                  icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
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
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.image_outlined, color: Colors.white),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.white),
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

  Future<void> _sendMessage() async {
    if (!mounted) return;

    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      await ref.read(chatServiceProvider).sendMessage(
            widget.chatId,
            message,
            currentUser.uid,
          );
      if (!mounted) return;
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      ref.read(errorNotifierProvider.notifier).setError(
            e is AppException ? e : AppException('메시지 전송에 실패했습니다'),
          );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/screens/chat/widgets/search/user_tile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../models/chat_room.dart';
import '../../models/user_model.dart';
import '../../core/cache/cache_provider.dart';
import '../../widgets/user/search_results.dart';
import '../../widgets/user/search_text_field.dart';
import '../../widgets/user/search_container.dart';
import 'widgets/chat_list/chat_rooms_list.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  String _searchText = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때 캐시 정리 스케줄러 활성화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheCleanupSchedulerProvider);
    });
  }

  Future<void> onUserTap(UserModel contact) async {
    try {
      final chatRoom = await ref.read(createChatRoomProvider(
        (participants: [contact.userId], groupName: null),
      ).future);
      if (mounted && context.mounted) {
        context.go('/chats/${chatRoom.id}');
      }
    } catch (e) {
      ref.read(errorNotifierProvider.notifier).setError(
            e is AppException ? e : AppException('채팅방 생성에 실패했습니다'),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider).value;
    final chatRoomsAsync = currentUser != null ? ref.watch(chatRoomsProvider(currentUser.uid)) : const AsyncValue<List<ChatRoom>>.data([]);
    final contactsAsync = _isSearching ? ref.watch(userSearchProvider(_searchText)) : const AsyncValue<List<UserModel>>.data([]);
    final userAsync = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.go('/home'),
        ),
        title: userAsync.when(
          data: (user) => Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                backgroundImage: user?.profileImage != null && user!.profileImage!.isNotEmpty ? NetworkImage(user.profileImage!) : null,
                child: user?.profileImage == null || user!.profileImage!.isEmpty
                    ? Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface, size: 20)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                user?.name ?? '채팅',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          loading: () => Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '로딩 중...',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
          error: (error, stack) {
            ref.read(errorNotifierProvider.notifier).setError(
                  error is AppException ? error : AppException('사용자 정보를 불러올 수 없습니다', details: error.toString()),
                );
            return Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(Icons.person, color: Theme.of(context).colorScheme.onSurface, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  '채팅',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14),
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () => ref.refresh(authProvider),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              context.push('/chats/new', extra: ref.read(authProvider).value);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색바
          SearchContainer(
            child: SearchTextField(
              hintText: '검색',
              onSearchingChanged: (isSearching) {
                setState(() {
                  _isSearching = isSearching;
                });
              },
              onTextChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
            ),
          ),
          // 검색 결과 또는 채팅방 목록
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _isSearching
                  ? contactsAsync.when(
                      data: (contacts) => SearchResults(
                        contacts: contacts,
                        isSearching: _isSearching,
                        itemBuilder: (context, user) => UserSearchTile(
                          user: user,
                          onTap: () => onUserTap(user),
                        ),
                      ),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (error, stack) => Center(
                        child: Text(
                          error is AppException ? error.message : '검색 중 오류가 발생했습니다',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  : ChatRoomsList(chatRoomsAsync: chatRoomsAsync),
            ),
          ),
        ],
      ),
    );
  }
}

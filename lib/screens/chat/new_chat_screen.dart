import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/screens/chat/widgets/search/user_tile.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/cache/cache_provider.dart';
import '../../widgets/user/search_results.dart';
import '../../widgets/user/search_text_field.dart';
import '../../widgets/user/search_container.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen> {
  bool _isSearching = false;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    // 캐시 정리 스케줄러 활성화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheCleanupSchedulerProvider);
    });
  }

  Future<void> onUserTap(UserModel contact) async {
    try {
      final chatRoom = await ref.read(createChatRoomProvider((
        participants: [ref.read(authProvider).value!.uid, contact.uid],
        groupName: null,
      )).future);

      if (!mounted || !context.mounted) return;
      context.go('/chats/${chatRoom.id}');
    } catch (e) {
      if (!mounted) return;
      ref.read(errorNotifierProvider.notifier).setError(
            e is AppException ? e : AppException('채팅방 생성에 실패했습니다'),
          );
    }
  }

  void _onCreateGroupTap() {
    context.push('/chats/new/group');
  }

  @override
  Widget build(BuildContext context) {
    // 검색 결과가 있을 때 자동으로 캐시에 저장
    final contactsAsync = _isSearching ? ref.watch(userSearchProvider(_searchText)) : const AsyncValue<List<UserModel>>.data([]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '새 메시지',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SearchContainer(
            child: SearchTextField(
              hintText: '사용자 검색',
              autofocus: true,
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
          // 그룹 채팅 만들기 버튼
          InkWell(
            onTap: _onCreateGroupTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.group_add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '그룹 채팅 만들기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: contactsAsync.when(
              data: (contacts) => SearchResults(
                contacts: contacts,
                isSearching: _isSearching,
                itemBuilder: (context, user) => UserSearchTile(
                  user: user,
                  onTap: () => onUserTap(user),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                if (!mounted) return const SizedBox.shrink();
                ref.read(errorNotifierProvider.notifier).setError(
                      error is AppException ? error : AppException('사용자 검색 중 오류가 발생했습니다'),
                    );
                return const Center(
                  child: Text(
                    '사용자 검색 중 오류가 발생했습니다',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

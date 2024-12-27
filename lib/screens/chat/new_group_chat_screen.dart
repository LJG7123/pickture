import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/screens/chat/widgets/search/user_tile.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../models/user_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../core/cache/cache_provider.dart';
import '../../widgets/user/search_results.dart';
import '../../widgets/user/search_text_field.dart';
import '../../widgets/user/search_container.dart';

class NewGroupChatScreen extends ConsumerStatefulWidget {
  const NewGroupChatScreen({super.key});

  @override
  ConsumerState<NewGroupChatScreen> createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends ConsumerState<NewGroupChatScreen> {
  final _groupNameController = TextEditingController();
  String _searchText = '';
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 캐시 정리 스케줄러 활성화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cacheCleanupSchedulerProvider);
    });
  }

  void _onUserTap(UserModel user) {
    ref.read(selectedUsersProvider.notifier).toggleUser(user);
  }

  Future<void> _onCreateGroupTap() async {
    final selectedUsers = ref.read(selectedUsersProvider);
    if (selectedUsers.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final chatRoom = await ref.read(createChatRoomProvider((
        participants: selectedUsers.map((user) => user.userId).toList(),
        groupName: _groupNameController.text.trim(),
      )).future);

      if (!mounted || !context.mounted) return;
      context.go('/chats/${chatRoom.id}');
    } catch (e) {
      if (!mounted) return;
      ref.read(errorNotifierProvider.notifier).setError(
            e is AppException ? e : AppException('그룹 채팅방 생성에 실패했습니다'),
          );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 검색 결과가 있을 때 자동으로 캐시에 저장
    final contactsAsync = _isSearching ? ref.watch(userSearchProvider(_searchText)) : const AsyncValue<List<UserModel>>.data([]);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '새 그룹 채팅',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _groupNameController,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: '그룹 이름(선택 사항)',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              SearchContainer(
                child: SearchTextField(
                  hintText: '사용자 검색',
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
              Expanded(
                child: contactsAsync.when(
                  data: (contacts) {
                    if (contacts.isEmpty && _searchText.isNotEmpty) {
                      return const Center(
                        child: Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return SearchResults(
                      contacts: contacts,
                      isSearching: _isSearching,
                      itemBuilder: (context, user) => UserSearchTile(
                        user: user,
                        onTap: () => _onUserTap(user),
                        isSelected: ref.watch(selectedUsersProvider).contains(user),
                      ),
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    ref.read(errorNotifierProvider.notifier).setError(error as AppException);
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
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: ref.watch(selectedUsersProvider).length >= 2 && !_isLoading
          ? FloatingActionButton(
              onPressed: _onCreateGroupTap,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(Icons.check, color: Theme.of(context).colorScheme.onPrimary),
            )
          : null,
    );
  }
}

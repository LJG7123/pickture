import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import 'widgets/user_search_tile.dart';
import '../../widgets/user/search_text_field.dart';
import '../../widgets/user/search_results.dart';

class NewGroupChatScreen extends ConsumerStatefulWidget {
  const NewGroupChatScreen({super.key});

  @override
  ConsumerState<NewGroupChatScreen> createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends ConsumerState<NewGroupChatScreen> {
  String _searchText = '';
  String _groupName = '';

  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void dispose() {
    ref.read(selectedUsersProvider.notifier).clearSelection();
    super.dispose();
  }

  void _toggleUserSelection(UserModel user) {
    ref.read(selectedUsersProvider.notifier).toggleUser(user);
  }

  Future<void> _createGroupChat() async {
    final selectedUsers = ref.read(selectedUsersProvider);
    if (selectedUsers.isEmpty) return;

    final currentUser = ref.read(authProvider).value;
    if (currentUser == null) {
      ref.read(errorNotifierProvider.notifier).setError(
            AppException('로그인이 필요합니다'),
          );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final participants = [
        currentUser.uid,
        ...selectedUsers.map((user) => user.uid)
      ];
      final chatId =
          await ref.read(createChatRoomProvider(participants).future);

      if (mounted && context.mounted) {
        context.go('/chats/$chatId');
      }
    } catch (e) {
      if (e is AppException) {
        ref.read(errorNotifierProvider.notifier).setError(e);
      } else {
        ref.read(errorNotifierProvider.notifier).setError(
              AppException('그룹 채팅방 생성에 실패했습니다'),
            );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = _isSearching
        ? ref.watch(userSearchProvider(_searchText))
        : const AsyncValue<List<UserModel>>.data([]);
    final selectedUsers = ref.watch(selectedUsersProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          '새 그룹 채팅',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SearchTextField(
                hintText: '그룹 이름(선택 사항)',
                autofocus: false,
                onTextChanged: (text) {
                  setState(() {
                    _groupName = text;
                  });
                },
              ),
              SearchTextField(
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
                        onTap: () => _toggleUserSelection(user),
                        isSelected: selectedUsers.contains(user),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    ref.read(errorNotifierProvider.notifier).setError(
                          error is AppException
                              ? error
                              : AppException('사용자 검색 중 오류가 발생했습니다'),
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
          if (_isLoading)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: selectedUsers.isNotEmpty && !_isLoading
          ? FloatingActionButton(
              onPressed: _createGroupChat,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.check, color: Colors.white),
            )
          : null,
    );
  }
}

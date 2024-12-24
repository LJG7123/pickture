import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/user/search_results.dart';
import '../../widgets/user/search_text_field.dart';
import '../../widgets/user/search_container.dart';
import 'widgets/user_search_tile.dart';

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

  void _toggleUserSelection(UserModel user) {
    ref.read(selectedUsersProvider.notifier).toggleUser(user);
  }

  Future<void> _createGroupChat() async {
    if (!mounted) return;

    final selectedUsers = ref.read(selectedUsersProvider);
    if (selectedUsers.length < 2) {
      ref.read(errorNotifierProvider.notifier).setError(
            AppException('그룹 채팅은 2명 이상의 참여자가 필요합니다'),
          );
      return;
    }

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

      final chatId = await ref.read(createChatRoomProvider((
        participants: participants,
        groupName: _groupName.trim().isNotEmpty ? _groupName.trim() : null,
      )).future);

      if (!mounted) return;

      // 로딩 상태를 먼저 해제
      setState(() {
        _isLoading = false;
      });

      if (!mounted || !context.mounted) return;

      // 화면 전환
      context.go('/chats/$chatId');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ref.read(errorNotifierProvider.notifier).setError(e as AppException);
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '그룹 이름(선택 사항)',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      _groupName = text;
                    });
                  },
                ),
              ),
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
                    ref
                        .read(errorNotifierProvider.notifier)
                        .setError(error as AppException);
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
      floatingActionButton: selectedUsers.length >= 2 && !_isLoading
          ? FloatingActionButton(
              onPressed: _createGroupChat,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.check, color: Colors.white),
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/error/app_exception.dart';
import '../../core/error/error_provider.dart';
import '../../models/user_model.dart';
import '../../providers/dm_contact_provider.dart';
import '../../providers/chat_provider.dart';
import 'widgets/search_results.dart';

class NewChatScreen extends ConsumerStatefulWidget {
  const NewChatScreen({super.key});

  @override
  ConsumerState<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends ConsumerState<NewChatScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> onUserTap(UserModel contact) async {
    await ref
        .read(chatRoomControllerProvider(contact.uid).notifier)
        .startChatWithUser(contact)
        .then((chatId) {
      if (mounted && context.mounted) {
        context.go('/chats/$chatId');
      }
    }).catchError((e) {
      ref.read(errorNotifierProvider.notifier).setError(e);
    });
  }

  void _onCreateGroupTap() {
    context.push('/chats/new/group');
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = _searchController.text;
    final contactsAsync = _isSearching && searchQuery.isNotEmpty
        ? ref.watch(dmContactSearchProvider(searchQuery))
        : const AsyncValue<List<UserModel>>.data([]);

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: '사용자 검색',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _isSearching = false;
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _isSearching = value.isNotEmpty;
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
              data: (contacts) {
                if (contacts.isEmpty) {
                  if (!_isSearching) {
                    return const Center(
                      child: Text(
                        '채팅할 상대를 검색해보세요',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      '검색 결과가 없습니다',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return SearchResults(
                  contacts: contacts,
                  onUserTap: onUserTap,
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text(
                  error is AppException ? error.message : '검색 중 오류가 발생했습니다',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

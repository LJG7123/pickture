import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/core/error/app_exception.dart';
import 'package:pickture/core/error/error_provider.dart';
import '../../models/user_model.dart';
import '../../providers/chat_provider.dart';
import '../../providers/dm_contact_provider.dart';
import '../../providers/auth_provider.dart';
import 'widgets/search_results.dart';
import 'widgets/chat_rooms_list.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomsAsync = ref.watch(chatRoomsProvider);
    final searchQuery = _searchController.text;
    final contactsAsync = _isSearching && searchQuery.isNotEmpty
        ? ref.watch(dmContactSearchProvider(searchQuery))
        : const AsyncValue<List<UserModel>>.data([]);
    final userAsync = ref.watch(authProvider);

    Future<void> onUserTap(UserModel contact) async {
      await ref
          .read(chatRoomControllerProvider(contact.uid).notifier)
          .startChatWithUser(contact)
          .then((chatId) {
        if (!mounted) return;
        context.go('/chats/$chatId');
      }).catchError((e) {
        ref.read(errorNotifierProvider.notifier).setError(e);
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: userAsync.when(
          data: (user) => Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[800],
                backgroundImage:
                    user?.profileImage != null && user!.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!)
                        : null,
                child: user?.profileImage == null || user!.profileImage!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                user?.name ?? '채팅',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          loading: () => const Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text(
                '로딩 중...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          error: (error, stack) {
            ref.read(errorNotifierProvider.notifier).setError(
                  error is AppException
                      ? error
                      : AppException('사용자 정보를 불러올 수 없습니다',
                          details: error.toString()),
                );
            return Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[800],
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  '채팅',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => ref.refresh(authProvider),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              context.push('/chats/new', extra: ref.read(authProvider).value);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return Column(
            children: [
              // 검색바
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '검색',
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
              // 검색 결과 또는 채팅방 목록
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: _isSearching
                      ? contactsAsync.when(
                          data: (contacts) => SearchResults(
                            contacts: contacts,
                            onUserTap: onUserTap,
                          ),
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (error, stack) => Center(
                            child: Text(
                              error is AppException
                                  ? error.message
                                  : '검색 중 오류가 발생했습니다',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      : ChatRoomsList(chatRoomsAsync: chatRoomsAsync),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/core/cache/cache_provider.dart';
import 'package:pickture/core/error/app_exception.dart';
import 'package:pickture/core/error/error_provider.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/providers/user_provider.dart';
import 'package:pickture/screens/chat/widgets/search/user_tile.dart';
import 'package:pickture/widgets/user/search_container.dart';
import 'package:pickture/widgets/user/search_results.dart';
import 'package:pickture/widgets/user/search_text_field.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _searchText = '';

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
      if (mounted && context.mounted) {
        context.push("/user_post", extra: contact);
      }
    } catch (e) {
      ref.read(errorNotifierProvider.notifier).setError(
            e is AppException ? e : AppException('채팅방 생성에 실패했습니다'),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(userSearchProvider(_searchText));

    return Scaffold(
      body: Column(
        children: [
          // 검색바
          SearchContainer(
            child: SearchTextField(
              hintText: '검색',
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
                child: contactsAsync.when(
                  data: (contacts) => SearchResults(
                    contacts: contacts,
                    isSearching: true,
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
                )),
          ),
        ],
      ),
    );
  }
}

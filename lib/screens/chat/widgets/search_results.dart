import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/error/error_provider.dart';
import '../../../models/user_model.dart';

class SearchResults extends ConsumerWidget {
  final AsyncValue<List<UserModel>> contactsAsync;
  final bool isSearching;

  const SearchResults({
    super.key,
    required this.contactsAsync,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return contactsAsync.when(
      data: (contacts) {
        if (contacts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.search_off,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  !isSearching ? '채팅할 상대를 검색해보세요' : '검색 결과가 없습니다.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
              onTap: () {
                // TODO: 채팅방 생성 또는 이동
              },
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stack) {
        if (error is AppException) {
          ref.read(errorNotifierProvider.notifier).setError(error);
        } else {
          ref.read(errorNotifierProvider.notifier).setError(
                AppException('검색 중 오류가 발생했습니다', details: error.toString()),
              );
        }
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, color: Colors.grey, size: 48),
              SizedBox(height: 16),
              Text(
                '다시 시도해주세요',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}

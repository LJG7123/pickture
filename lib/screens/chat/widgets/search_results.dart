import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/error/error_provider.dart';
import '../../../models/user_model.dart';

class SearchResults extends ConsumerWidget {
  final AsyncValue<List<UserModel>> contactsAsync;
  final bool isSearching;
  final Function(UserModel) onUserTap;

  const SearchResults({
    super.key,
    required this.contactsAsync,
    required this.isSearching,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return contactsAsync.when(
      data: (contacts) {
        if (contacts.isEmpty) {
          return const Center(
            child: Text(
              '검색 결과가 없습니다',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.grey[800],
                backgroundImage: contact.profileImage != null
                    ? NetworkImage(contact.profileImage!)
                    : null,
                child: contact.profileImage == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                    : null,
              ),
              title: Text(
                contact.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onTap: () => onUserTap(contact),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (error, stack) {
        ref.read(errorNotifierProvider.notifier).setError(
              error is AppException
                  ? error
                  : AppException('검색 중 오류가 발생했습니다', details: error.toString()),
            );
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

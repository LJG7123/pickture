import 'package:flutter/material.dart';
import '../../models/user_model.dart';

typedef OnUserTapCallback = Future<void> Function(UserModel contact);
typedef ItemBuilder = Widget Function(BuildContext context, UserModel user);

class SearchResults extends StatelessWidget {
  final List<UserModel> contacts;
  final ItemBuilder itemBuilder;
  final bool isSearching;

  const SearchResults({
    super.key,
    required this.contacts,
    required this.itemBuilder,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSearching) {
      return const SizedBox.shrink();
    }

    if (contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2),
              ),
              child: Icon(
                Icons.search_off_outlined,
                color: Theme.of(context).colorScheme.onSurface,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '검색 결과가 없습니다.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) => itemBuilder(context, contacts[index]),
    );
  }
}
